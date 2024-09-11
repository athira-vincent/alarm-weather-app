import 'package:alarm_app/data/model/alarm_model.dart';
import 'package:alarm_app/data/repositories/alarm_repository_impl.dart';
import 'package:alarm_app/presentation/bloc/alarm_bloc.dart';
import 'package:alarm_app/presentation/bloc/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreen extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text('Set Alarm')),


      body: Column(
        children: [
          BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              if (state is WeatherLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Current Weather: ${state.weatherDescription}'),
                );
              } else if (state is WeatherLoading) {
                return CircularProgressIndicator();
              } else {
                return Text('Failed to load weather');
              }
            },
          ),

          Expanded(
            child: BlocBuilder<AlarmBloc, AlarmState>(
            builder: (context, state) {
              if (state is AlarmListState) {
                if(state.alarms.isNotEmpty){
                  return ListView.builder(
                  itemCount: state.alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = state.alarms[index];
                    return ListTile(
                      title: Text(alarm.label),
                      //subtitle: Text(DateFormat('hh:mm a').format(alarm.time) ?? ''),
                       subtitle: Text(alarm.time.toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<AlarmBloc>().add(RemoveAlarmEvent(alarm.id));
                        },
                      ),
                    );
                  },
                );
              
                }else{
                  return Center(
                    child: Container(
                      child: Text("Alarm List is Empty"),
                    ),
                  );
                }
                
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
                    ),
          ),
      
        ],
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
           _showAddAlarmDialog(context);

          // context.read<AlarmBloc>().add(AddAlarmEvent(new Alarm(
          //   id: 1, isActive: true, label: "morning alarm", time: )));
        },
        child: Icon(Icons.add),
      ),
    );
  }


// new alarm dialog 
  void _showAddAlarmDialog(BuildContext context) {
  final TextEditingController labelController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add New Alarm'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Time picker
            ListTile(
              title: Text("Select Time: ${selectedTime.format(context)}"),
              trailing: Icon(Icons.access_time),
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (picked != null) {
                  selectedTime = picked;
                }
              },
            ),
            // Text field for label
            TextField(
              controller: labelController,
              decoration: InputDecoration(labelText: 'Alarm Label'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add the alarm
              if (labelController.text.isNotEmpty) {
                _addNewAlarm(context, selectedTime, labelController.text);
                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

void _addNewAlarm(BuildContext context, TimeOfDay time, String label) {
  final DateTime now = DateTime.now();
  final DateTime alarmTime = DateTime(
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  // Create a new Alarm object
  final alarm = Alarm(
    id: DateTime.now().millisecondsSinceEpoch, // Use a unique id
    label: label,
    isActive: true,
    time: alarmTime,
  );

  // Add the alarm using BLoC
  final alarmBloc = BlocProvider.of<AlarmBloc>(context);
  alarmBloc.add(AddAlarmEvent(alarm));

  // Optionally schedule the notification for the alarm
  scheduleAlarmNotification(alarm);
}

Future<void> scheduleAlarmNotification(Alarm alarm) async {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  await notificationsPlugin.zonedSchedule(
    0,
    alarm.label,
    'It\'s time!',
    tz.TZDateTime.from(alarm.time, tz.local),
    const NotificationDetails(
      android: AndroidNotificationDetails('alarm_channel', 'Alarms', ),
    ),
    androidAllowWhileIdle: true,

    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}

}
