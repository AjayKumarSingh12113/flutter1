import 'package:flutter/material.dart';
import '../../../models/weather_model.dart';
import '../../../services/weather_service.dart';

class WeatherController extends ChangeNotifier {

  final WeatherService _service = WeatherService();

  bool _isLoading = false;
  WeatherModel? _weather;

  bool get isLoading => _isLoading;
  WeatherModel? get weather => _weather;

  Future<void> getWeather() async {

    _isLoading = true;
    notifyListeners();

    try {
      _weather = await _service.fetchWeather();
    } catch (e) {
      print(e);
    }

    _isLoading = false;
    notifyListeners();
  }
}