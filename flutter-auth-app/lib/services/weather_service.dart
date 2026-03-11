import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_model.dart';

class WeatherService {

  String get apiKey => dotenv.env['WEATHER_API_KEY'] ?? '';

  Future<WeatherModel> fetchWeather(String city) async {

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return WeatherModel.fromJson(data);
    } else if (response.statusCode == 404) {
      throw Exception("City '$city' not found. Please check the spelling.");
    } else {
      throw Exception("Failed to fetch weather for $city. Please try again.");
    }
  }
}