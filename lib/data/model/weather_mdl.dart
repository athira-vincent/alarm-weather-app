class WeatherModel {
  final String description;
  final double temperature;

  WeatherModel({required this.description, required this.temperature});

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'],
    );
  }
}
