import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';

class WeatherService {

  String get apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  Future<WeatherModel> fetchWeather() async {

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=Delhi&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else {
      throw Exception("Weather API Error");
    }
  }
}