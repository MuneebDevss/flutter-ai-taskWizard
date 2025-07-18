
import 'package:task_wizard/Features/Shared/Data/Entities/collaboration_enitiy.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/recurrence_entity.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/reminder_entity.dart';

abstract class Task {
  String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final DateTime startDate;
  final String status;
  final int duration;
  final Recurrence recurrence;
  final List<Reminder> reminders;
  final Collaboration collaboration;
  final String? location;
  final String notes;
  DateTime? lastUpdated;
  Task( {
    required this.id,
    required this.status,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.startDate,
    
    required this.duration,
    required this.recurrence,
    required this.reminders,
    required this.collaboration,
    this.location,
    required this.notes,
  });

  Map<String, dynamic> toMap();
}
