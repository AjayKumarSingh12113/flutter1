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

    debugPrint('🔵 [WeatherController] getWeather() called');

    if (_weather != null) {
      debugPrint('🟡 [WeatherController] Weather data already loaded, skipping API call');
      return;
    }

    _isLoading = true;
    notifyListeners();

    debugPrint('🟢 [WeatherController] Starting Weather API call');

    try {
      _weather = await _service.fetchWeather();
      debugPrint('✅ [WeatherController] Weather API call successful - Location: ${_weather?.city}');
    } catch (e) {
      debugPrint('❌ [WeatherController] Weather API call failed: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}