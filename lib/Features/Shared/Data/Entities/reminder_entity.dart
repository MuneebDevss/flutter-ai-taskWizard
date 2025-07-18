import 'package:isar/isar.dart';
part 'reminder_entity.g.dart';
@embedded
class Reminder {
  late String type;
  late int minutesBefore;

  Reminder();

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder()
      ..type = map['type']
      ..minutesBefore = map['minutes_before'];
  }

  Map<String, dynamic> toMap() => {
    'type': type,
    'minutes_before': minutesBefore,
  };
}
