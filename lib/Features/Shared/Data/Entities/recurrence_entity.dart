import 'package:isar/isar.dart';
part 'recurrence_entity.g.dart';

@embedded
class Recurrence {
  late String type;
  late int interval;
  late List<int> daysOfWeek;
  late String? endDate;

  Recurrence();

  factory Recurrence.fromMap(Map<String, dynamic> map) {
    return Recurrence()
      ..type = map['type']
      ..interval = map['interval']
      ..daysOfWeek = List<int>.from(map['days_of_week'])
      ..endDate = map['end_date'];
  }

  Map<String, dynamic> toMap() => {
    'type': type,
    'interval': interval,
    'days_of_week': daysOfWeek,
    'end_date': endDate,
  };
}
