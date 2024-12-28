import 'package:flutter/material.dart';
import 'package:map_app/services/weather_service.dart';
import '../models/weather_models.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // API key
  final _weatherService = WeatherService('201f3c695f8ec25ca1423d5e29088acd');
  Weather? _weather;

  // Fetch weather
  _fetchWeather() async {
    // Get the current city
    String cityName = await _weatherService.getCurrentCity();

    // Get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // Initialize state
  @override
  void initState() {
    super.initState();
    _fetchWeather(); // Fetch weather on startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City name
            Text(_weather?.cityName ?? "Loading city..."),
            // Temperature
            Text('${_weather?.temperature?.round() ?? 'Loading'}°C'),
          ],
        ),
      ),
    );
  }
}
