class DailyInfoService {
  const DailyInfoService();

  String currentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute;
    final dayPart = _dayPart(hour);

    if (minute == 0) return 'Sekarang pukul $hour tepat, waktu $dayPart.';
    return 'Sekarang pukul $hour lewat $minute menit, waktu $dayPart.';
  }

  String currentDay() {
    final now = DateTime.now();
    return 'Hari ini ${_days[now.weekday - 1]}.';
  }

  String currentDate() {
    final now = DateTime.now();
    return 'Hari ini ${_days[now.weekday - 1]}, tanggal ${now.day} ${_months[now.month - 1]} ${now.year}.';
  }

  String _dayPart(int hour) {
    if (hour >= 4 && hour < 11) return 'pagi';
    if (hour >= 11 && hour < 15) return 'siang';
    if (hour >= 15 && hour < 18) return 'sore';
    return 'malam';
  }

  static const _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
  static const _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
}
