import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

//   Future<Map<String, dynamic>?> getWeather() async {
//     try {
//       final response = await _dio.get('https://api.openweathermap.org/data/2.5/weather', 
//       queryParameters: {
//         'lat': lat,
//         'lon': lon,
//         'appid': apiKey,
//       });
//       return response.data;
//     } catch (e) {
//       return null;
//     }


class WeatherService {
  final String apiKey = 'ea144cfc8498f5d5595284ba5f5d5e07'; // api key
  final Dio _dio = Dio();

  Future<String> getWeather() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    final double lat = position.latitude;
    final double lon = position.longitude;

    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric';
    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.data);
      final weather = data['weather'][0]['description'];
      final temp = data['main']['temp'];
      return '$weather, $temp°C';
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
