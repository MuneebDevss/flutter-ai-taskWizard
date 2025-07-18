import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:task_wizard/Features/Landing/Presentation/FetchTaskBlocs/fetch_task_bloc.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';

// Controller Class
class TaskScheduleController {
  var selectedDate = DateTime.now().obs;
  var normalTasks = <NormalTask>[].obs;

  void initializeSampleData() {
    // Sample data for demonstration
  }

  String getEndingTime(String taskTime, int duration) {
    final parts = taskTime.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    final startTime = DateTime(0, 1, 1, hour, minute);
    final endTime = startTime.add(Duration(minutes: duration));

    return "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";
  }

  List<NormalTask> getTasksForDate(DateTime date) {
    return normalTasks.where((task) {
        final taskDate = task.startDate;
        return taskDate.year == date.year &&
            taskDate.month == date.month &&
            taskDate.day == date.day;
      }).toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  void updateSelectedDate(DateTime date, BuildContext context) {
    selectedDate.value = date;
    context.read<FetchTaskBloc>().add(GetTasksByDateEvent(date));
  }

  String formatTime(String time) {
    final parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String period = hour >= 12 ? 'PM' : 'AM';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }
}

// Task Schedule Screen
