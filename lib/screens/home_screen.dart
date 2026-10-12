import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_sizes.dart';
import '../constants/app_texts.dart';
import '../models/app_command.dart';
import '../models/app_mode.dart';
import '../models/voice_state.dart';
import '../services/daily_info_service.dart';
import '../services/gemini_service.dart';
import '../services/location_service.dart';
import '../services/permission_service.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../services/weather_service.dart';
import '../widgets/answer_panel.dart';
import '../widgets/mode_header.dart';
import '../widgets/processing_indicator.dart';
import '../widgets/status_indicator.dart';
import '../widgets/voice_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tts = TtsService();
  final _speech = SpeechService();
  final _permission = const PermissionService();
  final _dailyInfo = const DailyInfoService();
  final _location = const LocationService();
  final _weather = const WeatherService();
  final _gemini = const GeminiService();
  final _parser = const CommandParser();

  AppMode _mode = AppMode.basic;
  VoiceState _voiceState = VoiceState.idle;
  String _statusMessage = VoiceState.idle.label;
  String _commandText = '';
  String _answerText = '';
  String _lastSpoken = '';

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  Future<void> _boot() async {
    await _tts.init();
    await _speak(AppTexts.enterBasic, nextState: VoiceState.permission);
    await _requestInitialPermissions();
    if (!mounted) return;
    setState(() {
      _voiceState = VoiceState.idle;
      _statusMessage = 'Ketuk tombol mikrofon atau ucapkan perintah.';
    });
    await _speak('Anda memasuki Mode Dasar. Aplikasi siap menerima perintah suara.');
  }

  Future<void> _requestInitialPermissions() async {
    await _speak(AppTexts.micPermissionInfo, nextState: VoiceState.permission);
    final micGranted = await _permission.requestMicrophone();
    await _speak(
      micGranted
          ? 'Terima kasih, izin mikrofon telah disetujui.'
          : 'Izin mikrofon ditolak. Aplikasi tidak dapat menerima perintah suara sampai izin diberikan.',
      nextState: micGranted ? VoiceState.speaking : VoiceState.error,
    );

    await _speak(AppTexts.locationPermissionInfo, nextState: VoiceState.permission);
    final locationGranted = await _permission.requestLocation();
    await _speak(
      locationGranted
          ? 'Terima kasih, izin lokasi telah disetujui.'
          : 'Izin lokasi ditolak. Informasi lokasi dan cuaca tidak dapat digunakan sampai izin diberikan.',
      nextState: locationGranted ? VoiceState.speaking : VoiceState.error,
    );
  }

  Future<void> _startListening() async {
    final hasMicrophone = await _permission.hasMicrophone();
    if (!hasMicrophone) {
      await _requestMicrophoneAgain();
      return;
    }

    HapticFeedback.lightImpact();
    await _tts.stop();
    if (!mounted) return;
    setState(() {
      _voiceState = VoiceState.listening;
      _statusMessage = VoiceState.listening.label;
      _commandText = '';
    });

    await _speech.listen(
      onResult: (words, isFinal) {
        if (!mounted) return;
        setState(() => _commandText = words);
        if (isFinal && words.trim().isNotEmpty) {
          _speech.stop();
          _handleCommand(words);
        }
      },
      onError: (error) => _showError(error),
    );
  }

  Future<void> _requestMicrophoneAgain() async {
    await _speak(AppTexts.micPermissionInfo, nextState: VoiceState.permission);
    final granted = await _permission.requestMicrophone();
    await _speak(
      granted ? 'Terima kasih, izin mikrofon telah disetujui.' : 'Izin mikrofon masih belum diberikan.',
      nextState: granted ? VoiceState.idle : VoiceState.error,
    );
  }

  Future<void> _handleCommand(String words) async {
    final command = _parser.parse(words, _mode);
    if (!mounted) return;
    setState(() {
      _voiceState = VoiceState.processing;
      _statusMessage = VoiceState.processing.label;
      _answerText = '';
    });

    try {
      switch (command.type) {
        case AppCommandType.time:
          await _answer(_dailyInfo.currentTime(), question: words);
        case AppCommandType.day:
          await _answer(_dailyInfo.currentDay(), question: words);
        case AppCommandType.date:
          await _answer(_dailyInfo.currentDate(), question: words);
        case AppCommandType.location:
          await _answerLocation(words);
        case AppCommandType.weather:
          await _answerWeather(words);
        case AppCommandType.switchToAi:
          await _switchMode(AppMode.ai);
        case AppCommandType.switchToBasic:
          await _switchMode(AppMode.basic);
        case AppCommandType.repeat:
          await _repeatLastAnswer();
        case AppCommandType.stop:
          await _tts.stop();
          _setIdle('Suara dihentikan.');
        case AppCommandType.listenAgain:
          await _startListening();
        case AppCommandType.askAi:
          await _answerAi(words);
        case AppCommandType.unknown:
          await _showError('Maaf, perintah belum dikenali. Anda dapat menanyakan jam, tanggal, lokasi, cuaca, atau berpindah mode.');
      }
    } catch (error) {
      await _showError(error.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _answerLocation(String question) async {
    final info = await _location.getCurrentLocation();
    await _answer('Lokasi Anda saat ini berada di ${info.address}.', question: question);
  }

  Future<void> _answerWeather(String question) async {
    final info = await _location.getCurrentLocation();
    final weather = await _weather.getCurrentWeather(latitude: info.latitude, longitude: info.longitude);
    final answer =
        'Lokasi Anda saat ini berada di ${info.address}. Cuaca di ${weather.locationName} saat ini ${weather.description}, suhu ${weather.temperature.round()} derajat Celsius, dan kecepatan angin ${weather.windSpeed.toStringAsFixed(1)} kilometer per jam.';
    await _answer(answer, question: question);
  }

  Future<void> _answerAi(String question) async {
    final answer = await _gemini.ask(question);
    await _answer(answer, question: question);
  }

  Future<void> _switchMode(AppMode mode) async {
    if (!mounted) return;
    setState(() {
      _mode = mode;
      _commandText = '';
      _answerText = '';
      _voiceState = VoiceState.speaking;
      _statusMessage = 'Berpindah ke ${mode.label}...';
    });
    HapticFeedback.lightImpact();
    await _speak(mode == AppMode.basic ? AppTexts.enterBasic : AppTexts.enterAi);
    _setIdle('Anda sedang berada di ${mode.label}.');
  }

  Future<void> _answer(String answer, {String? question}) async {
    if (!mounted) return;
    setState(() {
      _answerText = answer;
      _commandText = question ?? _commandText;
      _voiceState = VoiceState.speaking;
      _statusMessage = VoiceState.speaking.label;
    });
    _lastSpoken = answer;
    await _tts.speak(answer);
    HapticFeedback.lightImpact();
    _setIdle('Jawaban selesai dibacakan.');
  }

  Future<void> _repeatLastAnswer() async {
    if (_lastSpoken.isEmpty) {
      await _showError('Belum ada jawaban yang dapat diulangi.');
      return;
    }
    await _answer(_lastSpoken, question: _commandText);
  }

  Future<void> _showError(String message) async {
    if (!mounted) return;
    setState(() {
      _answerText = message;
      _voiceState = VoiceState.error;
      _statusMessage = message;
    });
    _lastSpoken = message;
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    HapticFeedback.heavyImpact();
    await _tts.speak(message);
    _setIdle('Silakan coba perintah kembali.');
  }

  Future<void> _speak(String message, {VoiceState nextState = VoiceState.speaking}) async {
    if (!mounted) return;
    setState(() {
      _voiceState = nextState;
      _statusMessage = message;
    });
    _lastSpoken = message;
    await _tts.speak(message);
  }

  void _setIdle(String message) {
    if (!mounted) return;
    setState(() {
      _voiceState = VoiceState.idle;
      _statusMessage = message;
    });
  }

  void _handleSwipe(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (velocity < -200 && _mode != AppMode.ai) {
      _switchMode(AppMode.ai);
    } else if (velocity > 200 && _mode != AppMode.basic) {
      _switchMode(AppMode.basic);
    }
  }

  Future<void> _dismissResult() async {
    await _tts.stop();
    if (!mounted) return;
    final msg = _mode == AppMode.basic
        ? 'Kembali ke Mode Dasar.'
        : 'Kembali ke Mode AI.';
    setState(() {
      _answerText = '';
      _voiceState = VoiceState.idle;
      _statusMessage = msg;
    });
    HapticFeedback.lightImpact();
    await _tts.speak(msg);
    _setIdle(msg);
  }

  void _handleDoubleTap() {
    if (_answerText.isNotEmpty) {
      _dismissResult();
      return;
    }
    if (_mode == AppMode.ai) {
      _switchMode(AppMode.basic);
    } else {
      if (_lastSpoken.isNotEmpty) {
        _repeatLastAnswer();
      } else {
        _startListening();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProcessing = _voiceState == VoiceState.processing;
    final isListening = _voiceState == VoiceState.listening;
    final isAi = _mode == AppMode.ai;

    final hasResult = _answerText.isNotEmpty;
    return PopScope(
      canPop: !hasResult,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _dismissResult();
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragEnd: _handleSwipe,
        onDoubleTap: _handleDoubleTap,
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.pagePadding),
              child: Column(
                children: [
                  ModeHeader(mode: _mode),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    child: isProcessing
                        ? const Column(
                            key: ValueKey('processing'),
                            children: [
                              Text('Memproses...', style: TextStyle(color: AppColors.dimText, fontSize: 18)),
                              SizedBox(height: 24),
                              ProcessingIndicator(),
                              SizedBox(height: 72),
                              Text('Sedang memproses perintah', style: TextStyle(fontSize: 16)),
                            ],
                          )
                        : hasResult
                            ? AnswerPanel(
                                key: const ValueKey('answer'),
                                question: isAi ? _commandText : null,
                                answer: _answerText,
                                onRepeat: _repeatLastAnswer,
                                onDismiss: _dismissResult,
                              )
                            : Column(
                                key: const ValueKey('listen'),
                                children: [
                                  if (!isAi)
                                    const Text(
                                      AppTexts.basicWelcome,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: AppSizes.fontTitle, fontWeight: FontWeight.w700),
                                    ),
                                  if (!isAi) const SizedBox(height: 32),
                                  VoiceButton(onPressed: _startListening, isListening: isListening),
                                  const SizedBox(height: 44),
                                  Text(
                                    _commandText.isNotEmpty
                                        ? '"$_commandText"'
                                        : isAi
                                            ? '"Siapa presiden Indonesia saat ini?"'
                                            : '"Jam berapa sekarang?"',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: AppSizes.fontCommand, height: 1.4),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    isAi ? AppTexts.aiHint : AppTexts.basicHint,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: AppColors.dimText, fontSize: AppSizes.fontHint),
                                  ),
                                ],
                              ),
                  ),
                  const Spacer(),
                  StatusIndicator(state: _voiceState, message: _statusMessage),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
