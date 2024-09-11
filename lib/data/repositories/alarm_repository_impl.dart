import 'dart:convert';

import 'package:alarm_app/core/utils/shared_pref_keys.dart';
import 'package:alarm_app/data/model/alarm_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmRepository {
  final AlarmRepositoryImpl localDataSource;

  AlarmRepository({required this.localDataSource});

  Future<void> addAlarm(Alarm alarm) async {
    await localDataSource.saveAlarm(alarm);
  }

  Future<List<Alarm>> fetchAlarms() async {
    return await localDataSource.getAlarms();
  }

  Future<void> removeAlarm(int id) async {
    await localDataSource.deleteAlarm(id);
  }
}

class AlarmRepositoryImpl {

  AlarmRepositoryImpl();

  Future<void> saveAlarm(Alarm alarm) async {
    // Code to save alarm to local storage (SharedPreferences)
    SharedPreferences _sharedPref = await SharedPreferences.getInstance()  ;
    final List<String>? alarmList = _sharedPref.getStringList(SharedPrefKey.alarmKey);
    final List<String> updatedAlarms = alarmList ?? [];
    updatedAlarms.add(jsonEncode(alarm.toJson()));
    await _sharedPref.setStringList(SharedPrefKey.alarmKey, updatedAlarms);

  }

  Future<List<Alarm>> getAlarms() async {
    // Code to fetch alarms from local storage

    SharedPreferences _sharedPref = await SharedPreferences.getInstance() ;
    final List<String>? alarmList = _sharedPref.getStringList(SharedPrefKey.alarmKey);
    if (alarmList == null) return [];
    return alarmList.map((alarmJson) => Alarm.fromJson(jsonDecode(alarmJson))).toList();

  }

  Future<void> deleteAlarm(int id) async {
    // Code to delete an alarm

    SharedPreferences _sharedPref = await SharedPreferences.getInstance()  ;

     final List<Alarm> alarms = await getAlarms();
    alarms.removeWhere((alarm) => alarm.id == id);
    await _sharedPref.setStringList(SharedPrefKey.alarmKey, alarms.map((a) => jsonEncode(a.toJson())).toList());
  }

  
}
