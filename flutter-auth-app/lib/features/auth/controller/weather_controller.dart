import 'package:flutter/material.dart';
import '../../../models/weather_model.dart';
import '../../../services/weather_service.dart';

class WeatherController extends ChangeNotifier {

  final WeatherService _service = WeatherService();

  bool _isLoading = false;
  WeatherModel? _weather;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  WeatherModel? get weather => _weather;
  String? get errorMessage => _errorMessage;

  Future<void> getWeather(String city) async {

    debugPrint('🔵 [WeatherController] getWeather() called for city: $city');

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint('🟢 [WeatherController] Starting Weather API call for $city');

    try {
      _weather = await _service.fetchWeather(city);
      _errorMessage = null;
      debugPrint('✅ [WeatherController] Weather API call successful - Location: ${_weather?.city}');
    } catch (e) {
      _weather = null;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      debugPrint('❌ [WeatherController] Weather API call failed: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}