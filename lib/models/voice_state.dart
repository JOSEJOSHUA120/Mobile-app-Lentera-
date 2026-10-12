enum VoiceState { idle, listening, processing, speaking, error, permission }

extension VoiceStateLabel on VoiceState {
  String get label => switch (this) {
    VoiceState.idle => 'Siap menerima perintah...',
    VoiceState.listening => 'Sedang mendengarkan...',
    VoiceState.processing => 'Sedang memproses...',
    VoiceState.speaking => 'Sedang berbicara...',
    VoiceState.error => 'Terjadi kesalahan...',
    VoiceState.permission => 'Meminta izin...',
  };
}
