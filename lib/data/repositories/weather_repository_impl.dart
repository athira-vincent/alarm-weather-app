import 'package:dio/dio.dart';

class WeatherService {
  final Dio _dio = Dio();
  final String apiKey = 'your_open_weather_map_api_key';

  Future<Map<String, dynamic>?> getWeather(double lat, double lon) async {
    try {
      final response = await _dio.get('https://api.openweathermap.org/data/2.5/weather', queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': apiKey,
      });
      return response.data;
    } catch (e) {
      return null;
    }
  }
}