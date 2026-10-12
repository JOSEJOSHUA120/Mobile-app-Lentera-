import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/location_info.dart';

class LocationService {
  const LocationService();

  Future<LocationInfo> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi pada perangkat belum aktif.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi belum diberikan.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final address = await _addressFromCoordinate(position.latitude, position.longitude);
    return LocationInfo(
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
    );
  }

  Future<String> _addressFromCoordinate(double latitude, double longitude) async {
    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return 'koordinat $latitude, $longitude';

      final place = placemarks.first;
      final parts = [
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.country,
      ].whereType<String>().where((part) => part.trim().isNotEmpty).toList();

      if (parts.isEmpty) return 'koordinat $latitude, $longitude';
      return parts.toSet().join(', ');
    } catch (_) {
      return 'koordinat $latitude, $longitude';
    }
  }
}
