import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar/isar.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/collaboration_enitiy.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/recurrence_entity.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/reminder_entity.dart';
part 'normal_task_entity.g.dart';

enum SyncStatus { add, update, delete, synced }

@collection
class NormalTask {
  Id isarId = Isar.autoIncrement;

  String id;
  String title;
  String description;
  String category;
  String priority;
  DateTime startDate;
  int duration;
  String status;
  String? location;
  String notes;
  @enumerated
  SyncStatus syncStatus;
  Recurrence recurrence;
  List<Reminder> reminders;
  Collaboration collaboration;

  NormalTask({
    this.syncStatus = SyncStatus.synced,
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.startDate,
    required this.duration,
    required this.status,
    this.location,
    required this.notes,
    required this.recurrence,
    required this.reminders,
    required this.collaboration,
  });

  factory NormalTask.fromMap(Map<String, dynamic> map) {
    return NormalTask(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      startDate: (map['start_date'] as Timestamp).toDate(),
      duration: map['duration'],
      status: map['status'],
      location: map['location'],
      notes: map['notes'],
      recurrence: Recurrence.fromMap(map['recurrence']),
      reminders:
          (map['reminders'] as List).map((r) => Reminder.fromMap(r)).toList(),
      collaboration: Collaboration.fromMap(map['collaboration']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'start_date': startDate,
      'duration': duration,
      'status': status,
      'location': location,
      'notes': notes,
      'recurrence': recurrence.toMap(),
      'reminders': reminders.map((r) => r.toMap()).toList(),
      'collaboration': collaboration.toMap(),
    };
  }

  NormalTask copyWith({
    Id? isarId,
    String? id,
    String? title,
    String? description,
    String? category,
    String? priority,
    DateTime? startDate,
    int? duration,
    String? status,
    String? location,
    String? notes,
    SyncStatus? syncStatus,
    Recurrence? recurrence,
    List<Reminder>? reminders,
    Collaboration? collaboration,
  }) {
    return NormalTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      startDate: startDate ?? this.startDate,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      syncStatus: syncStatus ?? this.syncStatus,
      recurrence: recurrence ?? this.recurrence,
      reminders: reminders ?? this.reminders,
      collaboration: collaboration ?? this.collaboration,
    )..isarId = isarId ?? this.isarId; // Set isarId manually after constructor
  }
}
