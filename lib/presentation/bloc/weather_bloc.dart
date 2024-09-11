import 'package:alarm_app/data/datasources/weather_remote_data_source.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


abstract class WeatherEvent {}
class FetchWeather extends WeatherEvent {}

abstract class WeatherState {}
class WeatherLoading extends WeatherState {}
class WeatherLoaded extends WeatherState {
  final String weatherDescription;
  WeatherLoaded(this.weatherDescription);
}
class WeatherError extends WeatherState {}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherService weatherService;
  
  WeatherBloc(this.weatherService) : super(WeatherLoading());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final weather = await weatherService.getWeather();
        yield WeatherLoaded(weather);
      } catch (e) {
        yield WeatherError();
      }
    }
  }
}
