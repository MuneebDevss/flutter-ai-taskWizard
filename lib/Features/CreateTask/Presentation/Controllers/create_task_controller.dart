import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/CreateTaskBlocs/bloc_events.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/CreateTaskBlocs/create_task_bloc.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/Services/notifications_controller.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';

class CreateTaskController {
  final NotificationsController _reminderScheduler;
  final List<String> priorities = [
    'High Priority',
    'Medium Priorty',
    'Low Priorty',
    'No Priorty',
  ];
  final List<String> categories = [
    'No Category',
    'Work',
    'Personal',
    'Health',
    'Birthday',
    'Create New',
  ];

  CreateTaskController({required NotificationsController reminderScheduler})
    : _reminderScheduler = reminderScheduler;

  /// Add a task by dispatching an event to the Bloc and scheduling a reminder
  Future<void> addTask(BuildContext context, NormalTask task) async {
    // Dispatch the event to the Bloc
    context.read<AddTaskBloc>().add(AddTaskEvent(task));
    // Schedule reminder (10 minutes before start, for example)
    // if (task.id != null) {
    //   await _reminderScheduler.scheduleTaskReminder(task, task.id!);
    // }
  }

  /// Update a task: cancel old reminder, update in Bloc, reschedule
  Future<void> updateTask(
    BuildContext context,
    String id,
    NormalTask task,
  ) async {
    await _reminderScheduler.cancelTaskReminder(id);

    context.read<AddTaskBloc>().add(UpdateTaskEvent(id, task));

    await NotificationsController.scheduleTaskReminder(task, id);
  }

  /// Delete a task: cancel reminder, dispatch delete
  Future<void> deleteTask(BuildContext context, String id) async {
    await _reminderScheduler.cancelTaskReminder(id);

    context.read<AddTaskBloc>().add(DeleteTaskEvent(id));
  }

  /// Load all tasks
  void loadAllTasks(BuildContext context) {
    context.read<AddTaskBloc>().add(GetAllTasksEvent());
  }
}
