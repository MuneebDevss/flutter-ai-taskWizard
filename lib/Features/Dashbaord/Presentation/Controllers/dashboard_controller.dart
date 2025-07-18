import 'dart:ui' show Color;

import 'package:flutter/material.dart' show Colors;
import 'package:task_wizard/Features/Auth/data/user.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';

class DashboardController {
  final UserModel user = UserModel(
    'id',
    email: 'email',
    userName: 'userName',
    phoneNumber: 'phoneNumber',
    profilePicture: 'profilePicture',
  );
  final List<NormalTask> tasks = [];

  int currentCompletedTasks = 0;

  int totalCurrentTasks = 0;
  Color progressColor = Colors.grey;

  int selectedIndex = 0;

  void getProgressSummary() {
    final now = DateTime.now();

    final todaysTasks =
        tasks.where((t) {
          final taskDate = t.startDate;
          return taskDate.year == now.year &&
              taskDate.month == now.month &&
              taskDate.day == now.day;
        }).toList();

    currentCompletedTasks =
        todaysTasks.where((task) => task.status == 'completed').length;
    totalCurrentTasks = todaysTasks.length;

    double percent = currentCompletedTasks / totalCurrentTasks;
    progressColor = HelpingFunctions.getProgressColor(
      totalCurrentTasks,
      percent,
    );
  }

  List<Map<String, dynamic>> getTopCategoryProgress() {
    // Step 1: Filter tasks for the current day
    final now = DateTime.now();
    final todayTasks =
        tasks.where((t) {
          final taskDate = t.startDate;
          return taskDate.year == now.year &&
              taskDate.month == now.month &&
              taskDate.day == now.day;
        }).toList();

    // Step 2: Only use these categories
    final List<String> categories = ['Work', 'Personal', 'Health'];

    // Step 3: Group tasks by category
    final Map<String, List<NormalTask>> categoryMap = {
      for (var cat in categories) cat: [],
    };
    for (var task in todayTasks) {
      if (categories.contains(task.category)) {
        categoryMap[task.category]!.add(task);
      }
    }

    // Step 4: Calculate progress per category (always return all three)
    return categories.map((category) {
      final categoryTasks = categoryMap[category] ?? [];
      final completed =
          categoryTasks.where((t) => t.status == 'completed').length;
      final left = categoryTasks.length - completed;
      final percentDone =
          categoryTasks.isEmpty
              ? 0.0
              : ((completed / categoryTasks.length) * 100);
      return {
        'category': category,
        'percentageDone': percentDone,
        'tasksCompleted': completed,
        'tasksLeft': left,
      };
    }).toList();
  }

  List<NormalTask> getOngoingTasks() {
    final now = DateTime.now();
    final ongoing =
        tasks.where((task) {
          return (task.status == 'pending' || task.status == 'in_progress') &&
              task.startDate.year == now.year &&
              task.startDate.month == now.month &&
              task.startDate.day == now.day;
        }).toList();
    // Sort by start date and time
    ongoing.sort((a, b) {
      final first = a.startDate;
      final second = b.startDate;
      return first.compareTo(second);
    });

    return ongoing.take(5).toList();
  }

  List<NormalTask> getDailyRecurringTasks(List<NormalTask> allTasks) {
    return allTasks
        .where((task) => task.recurrence.type.toLowerCase() == 'daily')
        .toList();
  }
}
