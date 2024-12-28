import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_models.dart';
import 'package:geolocator/geolocator.dart'; // Import needed for geolocation
import 'package:geocoding/geocoding.dart'; // Import needed for placemarkFromCoordinates

class WeatherService {
  static const String baseUrl = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Get permission from the user
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );

    // Convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Extract the city name from the first placemark
    String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;

    return city ?? "";
  }
}
