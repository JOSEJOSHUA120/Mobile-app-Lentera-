import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  SpeechService();

  final SpeechToText _speech = SpeechToText();
  bool _ready = false;

  Future<bool> init() async {
    _ready = await _speech.initialize();
    return _ready;
  }

  Future<void> listen({
    required void Function(String words, bool isFinal) onResult,
    required void Function(String error) onError,
  }) async {
    if (!_ready) {
      final initialized = await init();
      if (!initialized) {
        onError('Speech-to-Text belum tersedia di perangkat ini.');
        return;
      }
    }

    await _speech.listen(
      listenOptions: SpeechListenOptions(partialResults: true, localeId: 'id_ID'),
      onResult: (SpeechRecognitionResult result) {
        onResult(result.recognizedWords, result.finalResult);
      },
    );
  }

  Future<void> stop() => _speech.stop();
}
