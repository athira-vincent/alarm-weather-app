import 'package:alarm_app/data/datasources/weather_remote_data_source.dart';
import 'package:alarm_app/data/repositories/alarm_repository_impl.dart';
import 'package:alarm_app/presentation/bloc/alarm_bloc.dart';
import 'package:alarm_app/presentation/bloc/weather_bloc.dart';
import 'package:alarm_app/presentation/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final remoteDataSource = new AlarmRepositoryImpl();
  final alarmRepository = AlarmRepository(localDataSource: remoteDataSource);   

   tz.initializeTimeZones();
   //await _initializeNotifications();

  runApp(MyApp(repository: alarmRepository,));
}

Future<void> _initializeNotifications() async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


class MyApp extends StatelessWidget {
final AlarmRepository repository;

  const MyApp({
    super.key,
    required this.repository
    });

  // This widget is the root of your application.

  // final sharedPreferences = await SharedPreferences.getInstance();
  // alarmBloc = AlarmBloc(AlarmRepositoryImpl(sharedPreferences));
    
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AlarmBloc>(
                    create: (context) => AlarmBloc(alarmRepository: repository),
                  ),
        BlocProvider<WeatherBloc>(
                    create: (context) => WeatherBloc(WeatherService()),
                  ),          
      ],

      child: MaterialApp(
        title: 'Alarm App',
        theme: ThemeData(
          
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}



