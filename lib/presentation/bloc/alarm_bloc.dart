import 'package:alarm_app/data/model/alarm_model.dart';
import 'package:alarm_app/data/repositories/alarm_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmEvent {}

class AddAlarmEvent extends AlarmEvent {
  final Alarm alarm;

  AddAlarmEvent(this.alarm);
}

class RemoveAlarmEvent extends AlarmEvent {
  final int alarmId;

  RemoveAlarmEvent(this.alarmId);
}

class AlarmState {}

class AlarmListState extends AlarmState {
  final List<Alarm> alarms;

  AlarmListState(this.alarms);
}

class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmRepository alarmRepository;

  AlarmBloc({required this.alarmRepository}) : super(AlarmListState([])) {
    on<AddAlarmEvent>((event, emit) async {
      await alarmRepository.addAlarm(event.alarm);
      List<Alarm> alarms = await alarmRepository.fetchAlarms();
      emit(AlarmListState(alarms));
    });

    on<RemoveAlarmEvent>((event, emit) async {
      await alarmRepository.removeAlarm(event.alarmId);
      List<Alarm> alarms = await alarmRepository.fetchAlarms();
      emit(AlarmListState(alarms));
    });
  }
}
