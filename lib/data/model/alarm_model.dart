class Alarm {
  final int id;
  final String label;
  final DateTime time;
  final bool isActive;

  Alarm({required this.id, required this.label, required this.time, required this.isActive});

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'time': time.toIso8601String(),
    'isActive': isActive ? 1 : 0,
  };

  static Alarm fromJson(Map<String, dynamic> json) => Alarm(
    id: json['id'],
    label: json['label'],
    time: DateTime.parse(json['time']),
    isActive: json['isActive'] == 1,
  );
}
