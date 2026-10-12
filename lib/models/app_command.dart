import 'app_mode.dart';

enum AppCommandType {
  time,
  day,
  date,
  location,
  weather,
  switchToAi,
  switchToBasic,
  repeat,
  stop,
  listenAgain,
  askAi,
  unknown,
}

class AppCommand {
  const AppCommand(this.type, this.text);

  final AppCommandType type;
  final String text;
}

class CommandParser {
  const CommandParser();

  AppCommand parse(String input, AppMode mode) {
    final text = input.toLowerCase().trim();

    if (text.isEmpty) return const AppCommand(AppCommandType.unknown, '');
    if (_hasAny(text, ['mode ai', 'mode gemini', 'pindah ke ai', 'pindah ke mode ai'])) {
      return AppCommand(AppCommandType.switchToAi, input);
    }
    if (_hasAny(text, ['mode dasar', 'pindah ke dasar', 'pindah ke mode dasar'])) {
      return AppCommand(AppCommandType.switchToBasic, input);
    }
    if (_hasAny(text, ['ulangi', 'ulang jawaban', 'ulangi jawaban'])) {
      return AppCommand(AppCommandType.repeat, input);
    }
    if (_hasAny(text, ['berhenti bicara', 'stop bicara', 'diam'])) {
      return AppCommand(AppCommandType.stop, input);
    }
    if (_hasAny(text, ['dengarkan lagi', 'dengar lagi', 'mulai dengar'])) {
      return AppCommand(AppCommandType.listenAgain, input);
    }

    if (mode == AppMode.ai) return AppCommand(AppCommandType.askAi, input);

    if (_hasAny(text, ['jam berapa', 'pukul berapa', 'waktu sekarang'])) {
      return AppCommand(AppCommandType.time, input);
    }
    if (_hasAny(text, ['hari apa', 'hari ini'])) {
      return AppCommand(AppCommandType.day, input);
    }
    if (_hasAny(text, ['tanggal berapa', 'tanggal sekarang'])) {
      return AppCommand(AppCommandType.date, input);
    }
    if (_hasAny(text, ['lokasi', 'dimana saya', 'di mana saya', 'saya ada dimana', 'saya ada di mana'])) {
      return AppCommand(AppCommandType.location, input);
    }
    if (_hasAny(text, ['cuaca', 'hujan', 'suhu'])) {
      return AppCommand(AppCommandType.weather, input);
    }

    return AppCommand(AppCommandType.unknown, input);
  }

  bool _hasAny(String text, List<String> keywords) {
    return keywords.any(text.contains);
  }
}
