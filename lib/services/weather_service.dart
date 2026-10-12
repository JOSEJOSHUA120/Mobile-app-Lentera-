import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_info.dart';

class WeatherService {
  const WeatherService();

  Future<WeatherInfo> getCurrentWeather({required double latitude, required double longitude}) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'current_weather': 'true',
      'timezone': 'auto',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw Exception('Informasi cuaca tidak dapat diperoleh.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final currentWeather = data['current_weather'] as Map<String, dynamic>;

    final weatherCode = currentWeather['weathercode'] as int;
    final description = _weatherCodeToDescription(weatherCode);

    return WeatherInfo(
      description: description,
      temperature: (currentWeather['temperature'] as num).toDouble(),
      humidity: 0,
      windSpeed: (currentWeather['windspeed'] as num).toDouble(),
      locationName: 'lokasi Anda',
    );
  }

  String _weatherCodeToDescription(int code) {
    const descriptions = {
      0: 'langit cerah',
      1: 'sebagian besar cerah',
      2: 'berawan sebagian',
      3: 'berawan penuh',
      45: 'berkabut',
      48: 'kabut tebal dengan embun beku',
      51: 'gerimis ringan',
      53: 'gerimis sedang',
      55: 'gerimis lebat',
      56: 'gerimis beku ringan',
      57: 'gerimis beku lebat',
      61: 'hujan ringan',
      63: 'hujan sedang',
      65: 'hujan lebat',
      66: 'hujan beku ringan',
      67: 'hujan beku lebat',
      71: 'salju ringan',
      73: 'salju sedang',
      75: 'salju lebat',
      77: 'butiran salju',
      80: 'hujan ringan sesekali',
      81: 'hujan sedang sesekali',
      82: 'hujan lebat sesekali',
      85: 'salju ringan sesekali',
      86: 'salju lebat sesekali',
      95: 'badai petir',
      96: 'badai petir dengan hujan es ringan',
      99: 'badai petir dengan hujan es lebat',
    };

    return descriptions[code] ?? 'kondisi cuaca tidak diketahui';
  }
}
