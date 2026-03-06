class WeatherModel {
  final String city;
  final double temp;
  final int humidity;
  final double wind;
  final String condition;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.humidity,
    required this.wind,
    required this.condition,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json["name"],
      temp: (json["main"]["temp"]).toDouble(),
      humidity: json["main"]["humidity"],
      wind: (json["wind"]["speed"]).toDouble(),
      condition: json["weather"][0]["main"],
    );
  }
}