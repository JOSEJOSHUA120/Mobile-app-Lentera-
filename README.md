# LENTERA

LENTERA adalah aplikasi informasi harian berbasis suara untuk pengguna tunanetra. Aplikasi ini memakai konsep voice-first: pengguna memberi perintah suara, aplikasi memproses perintah, lalu hasil dibacakan kembali melalui Text-to-Speech.

## Fitur Utama

- Splash screen dengan logo LENTERA
- Mode Dasar untuk waktu, hari, tanggal, lokasi, dan cuaca
- Mode AI untuk bertanya ke Gemini
- Swipe kiri untuk masuk Mode AI
- Swipe kanan untuk kembali ke Mode Dasar
- **Double tap untuk shortcut:** Mode AI → Mode Dasar, Mode Dasar → ulangi jawaban
- Text-to-Speech untuk feedback mode, permission, jawaban, dan error
- Speech-to-Text untuk menerima perintah suara
- **Vibration feedback** saat pindah mode, error, dan mulai listening
- **Animasi tombol mikrofon** dengan scale dan glow effect
- Permission flow dengan penjelasan suara sebelum dialog Android muncul
- Lokasi real-time menggunakan GPS
- **Cuaca online menggunakan Open-Meteo** (gratis, tanpa API key)
- Gemini AI dengan placeholder, aktif setelah API key diisi
- Error state untuk permission, API key, jaringan/API, lokasi, cuaca, dan perintah tidak dikenali
- **UI yang lebih besar dan lebih rapi** dengan font lebih mudah dibaca

## Struktur Folder

```text
lib/
  main.dart                  Entry point aplikasi dan load .env.
  app.dart                   Konfigurasi MaterialApp dan theme utama.

  config/
    app_config.dart          Membaca API key Gemini.

  constants/
    app_colors.dart          Warna utama aplikasi.
    app_sizes.dart           Ukuran spacing/radius/tombol/font.
    app_texts.dart           Teks voice feedback utama.

  models/
    app_command.dart         Parser perintah suara.
    app_mode.dart            Mode Dasar dan Mode AI.
    location_info.dart       Model data lokasi.
    voice_state.dart         State mendengarkan, memproses, berbicara, error.
    weather_info.dart        Model data cuaca.

  screens/
    splash_screen.dart       Splash screen LENTERA.
    home_screen.dart         UI utama Mode Dasar dan Mode AI.

  services/
    daily_info_service.dart  Informasi jam, hari, dan tanggal offline.
    gemini_service.dart      Request ke Gemini API.
    location_service.dart    GPS dan reverse geocoding.
    permission_service.dart  Permission microphone dan location.
    speech_service.dart      Speech-to-Text.
    tts_service.dart         Text-to-Speech.
    weather_service.dart     Request cuaca Open-Meteo.

  widgets/
    answer_panel.dart        Panel jawaban dan tombol ulangi suara.
    mode_header.dart         Header Mode Dasar/Mode AI dengan badge.
    processing_indicator.dart Loading indicator.
    status_indicator.dart    Status bawah aplikasi dengan animasi pulse.
    voice_button.dart        Tombol mikrofon dengan animasi scale.
```

## Konfigurasi API Key

File `.env` sudah disiapkan dengan placeholder kosong.

```env
GEMINI_API_KEY=
```

Isi API key Gemini Anda sendiri agar Mode AI aktif.

```env
GEMINI_API_KEY=api_key_gemini_anda
```

**Catatan:** Cuaca menggunakan Open-Meteo yang gratis tanpa API key, jadi tidak perlu konfigurasi tambahan.

Jika Gemini API key belum diisi, Mode AI akan membacakan pesan bahwa API key belum diatur.

## Gesture dan Shortcut

- **Swipe kiri:** Pindah dari Mode Dasar ke Mode AI
- **Swipe kanan:** Pindah dari Mode AI ke Mode Dasar
- **Double tap di Mode AI:** Kembali ke Mode Dasar
- **Double tap di Mode Dasar:** Ulangi jawaban terakhir

## Contoh Voice Command

Mode Dasar:

- `Jam berapa sekarang?`
- `Hari ini hari apa?`
- `Tanggal berapa sekarang?`
- `Saya ada di mana?`
- `Bagaimana cuaca sekarang?`
- `Pindah ke mode AI`

Mode AI:

- `Siapa presiden Indonesia saat ini?`
- `Jelaskan tentang tata surya`
- `Apa itu kecerdasan buatan?`
- `Pindah ke mode dasar`

Command tambahan:

- `Ulangi jawaban`
- `Berhenti bicara`
- `Dengarkan lagi`

## Cara Mengubah Desain

- **Warna utama:** edit `lib/constants/app_colors.dart`
- **Ukuran font:** edit konstanta font di `lib/constants/app_sizes.dart`
- **Spacing/radius/tombol:** edit `lib/constants/app_sizes.dart`
- **Teks feedback suara:** edit `lib/constants/app_texts.dart`
- **Logo SVG:** ganti `assets/icons/lentera_logo.svg`
- **Launcher icon:** ganti `assets/icons/lentera_launcher_icon.png`, lalu jalankan `dart run flutter_launcher_icons`

## Cara Menambah Voice Command

1. Buka `lib/models/app_command.dart`
2. Tambahkan enum baru di `AppCommandType`
3. Tambahkan keyword di `CommandParser.parse`
4. Buka `lib/screens/home_screen.dart`
5. Tambahkan handler command di method `_handleCommand`

## Perintah Development

Install dependency:

```bash
flutter pub get
```

Analyze kode:

```bash
flutter analyze
```

Jalankan aplikasi:

```bash
flutter run
```

Build debug APK:

```bash
flutter build apk --debug
```

Build release APK:

```bash
flutter build apk --release
```

## Catatan Testing

Fitur TTS, STT, mikrofon, permission lokasi, dan GPS paling akurat dites di perangkat Android fisik. Emulator/desktop dapat memiliki keterbatasan microphone, speech recognition, dan GPS.

## Vibration Feedback

Aplikasi menggunakan haptic feedback untuk pengalaman yang lebih baik:

- **Light vibration:** Pindah mode, mulai listening, selesai berbicara
- **Heavy vibration (2x):** Error


## Animasi UI

- **Tombol mikrofon:** Scale animation ketika ditekan dan glow pulse saat listening
- **Status indicator:** Pulse animation saat listening atau processing
- **Smooth transitions:** AnimatedSwitcher untuk perpindahan state

## Batasan Saat Ini

- Gemini membutuhkan `GEMINI_API_KEY`
- Release APK saat ini memakai debug signing bawaan Flutter
- Untuk Play Store, gunakan keystore resmi milik pemilik aplikasi
len
