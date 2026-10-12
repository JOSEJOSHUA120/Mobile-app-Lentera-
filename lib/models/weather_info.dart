class WeatherInfo {
  const WeatherInfo({
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.locationName,
  });

  final String description;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String locationName;
}
