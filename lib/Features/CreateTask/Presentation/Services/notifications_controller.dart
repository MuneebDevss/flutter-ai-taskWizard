import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/main.dart';

class NotificationsController {
  // Initialize AwesomeNotifications
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications().initialize(
      null, // Use default app icon
      [
        NotificationChannel(
          channelKey: 'task_reminders',
          channelName: 'Task Reminders',
          channelDescription: 'Notifications for upcoming tasks',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
    );

    // Request notification permissions
    await _requestNotificationPermissions();
  }

  static Future<void> _requestNotificationPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Request permission
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  static Future<void> scheduleTaskReminder(
    NormalTask task,
    String taskId,
  ) async {
    try {
      // Calculate reminder time (10 minutes before task start)
      if (task.reminders.isEmpty) {
        return;
      }
      final recurrence = task.recurrence;
      final taskStartTime = task.startDate;
      final taskReminder = task.reminders[0];
      final reminderTime = taskStartTime.subtract(
        Duration(minutes: taskReminder.minutesBefore),
      );

      // Only schedule if reminder time is in the future
      if (reminderTime.isBefore(DateTime.now())) {
        return;
      }
      if (taskReminder.type == 'None') {
        await createNotification(
          taskId,
          task,
          taskStartTime,
          NotificationCalendar.fromDate(
            date: reminderTime,
            allowWhileIdle: true,
          ),
        );
      } else if (taskReminder.type == 'Daily') {
        await createNotification(
          taskId,
          task,
          taskStartTime,
          NotificationCalendar(
            hour: reminderTime.hour,
            minute: reminderTime.minute,
            second: 0,
            millisecond: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
      } else if (taskReminder.type == 'Weekly') {
          if (recurrence.daysOfWeek.isEmpty) {
            await createNotification(
          taskId,
          task,
          taskStartTime,
          NotificationCalendar(
            weekday: reminderTime.weekday,
            hour: reminderTime.hour,
            minute: reminderTime.minute,
            second: 0,
            millisecond: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
          }
          else{
            for (final day in recurrence.daysOfWeek){
              await createNotification(
          taskId,
          task,
          taskStartTime,
          NotificationCalendar(
            weekday: day,
            hour: reminderTime.hour,
            minute: reminderTime.minute,
            second: 0,
            millisecond: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
            }
          }
      } else if (taskReminder.type == 'Monthly') {
        if (recurrence.daysOfWeek.isEmpty) {
            await createNotification(
          taskId,
          task,
          taskStartTime,
          NotificationCalendar(
            day: reminderTime.day,
            hour: reminderTime.hour,
            minute: reminderTime.minute,
            second: 0,
            millisecond: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
          }
          else{
            for (final day in recurrence.daysOfWeek){
              await createNotification(
          taskId,
          task,
          taskStartTime,
          NotificationCalendar(
            day: day,
            hour: reminderTime.hour,
            minute: reminderTime.minute,
            second: 0,
            millisecond: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
            }
          }
        
      } else if (taskReminder.type == 'Yearly') {
        if (recurrence.daysOfWeek.isEmpty) {
            await createNotification(
          taskId,
          task,
          taskStartTime,
          NotificationCalendar(
            month: reminderTime.month,
            day: reminderTime.day,
            hour: reminderTime.hour,
            minute: reminderTime.minute,
            second: 0,
            millisecond: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
          }
          else{
            for (final day in recurrence.daysOfWeek){
              await createNotification(
          taskId,
          task,
          taskStartTime,
          NotificationCalendar(
            month: reminderTime.month,
            day: day,
            hour: reminderTime.hour,
            minute: reminderTime.minute,
            second: 0,
            millisecond: 0,
            repeats: true,
            allowWhileIdle: true,
          ),
        );
            }
          }
        
      }

      // Schedule the notification
    } catch (e) {
      throw Exception('Failed to schedule reminder: $e');
    }
  }

  static Future<void> createNotification(
    String taskId,
    NormalTask task,
    DateTime taskStartTime,
    NotificationCalendar notificationCalender,
  ) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: taskId.hashCode, // Use taskId hash as unique notification ID
        channelKey: 'task_reminders',
        title: '📝 Task Reminder',
        body: '${task.title} starts in 10 minutes',
        bigPicture: null,

        notificationLayout: NotificationLayout.Default,
        payload: {
          'taskId': taskId,
          'taskTitle': task.title,
          'taskDescription': task.description ?? '',
          'taskStartTime': taskStartTime.toIso8601String(),
        },
        category: NotificationCategory.Reminder,
        wakeUpScreen: true,
        fullScreenIntent: false,
      ),

      schedule: notificationCalender,
      actionButtons: [
        NotificationActionButton(
          key: 'VIEW_TASK',
          label: 'View Task',
          autoDismissible: true,
        ),
        NotificationActionButton(
          key: 'SNOOZE',
          label: 'Snooze 5min',
          autoDismissible: false,
        ),
      ],
    );
  }

  Future<void> cancelTaskReminder(String taskId) async {
    try {
      // Cancel the notification using the taskId hash as the notification ID
      await AwesomeNotifications().cancel(taskId.hashCode);
      print('Reminder cancelled successfully for task: $taskId');
    } catch (e) {
      print('Error cancelling reminder: $e');
    }
  }

  Future<void> cancelAllReminders() async {
    try {
      await AwesomeNotifications().cancelAll();
      print('All reminders cancelled successfully');
    } catch (e) {
      print('Error cancelling all reminders: $e');
    }
  }

  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
    ReceivedNotification receivedNotification,
  ) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    // Your code goes here
  }

  // Handle notification actions (like when user taps notification or action buttons)
  @pragma("vm:entry-point")
  static Future<void> handleNotificationAction(
    ReceivedAction receivedAction,
  ) async {
    final payload = receivedAction.payload;
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/notification-page',
      (route) => (route.settings.name != '/notification-page') || route.isFirst,
      arguments: receivedAction,
    );
    switch (receivedAction.actionType) {
      case ActionType.SilentAction:
      case ActionType.SilentBackgroundAction:
        // Handle silent actions
        break;

      case ActionType.Default:
        // User tapped the notification
        print('User tapped notification for task: ${payload?['taskTitle']}');
        // Navigate to task details or appropriate screen
        break;

      case ActionType.DismissAction:
        // User tapped an action button
        if (receivedAction.buttonKeyPressed == 'VIEW_TASK') {
          print('User wants to view task: ${payload?['taskTitle']}');
          // Navigate to task details
        } else if (receivedAction.buttonKeyPressed == 'SNOOZE') {
          // Snooze the reminder for 5 minutes
          await _snoozeReminder(payload);
        }
        break;

      case null:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ActionType.InputField:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ActionType.DisabledAction:
        // TODO: Handle this case.
        throw UnimplementedError();
      case ActionType.KeepOnTop:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static Future<void> _snoozeReminder(Map<String, String?>? payload) async {
    if (payload == null) return;

    try {
      final taskTitle = payload['taskTitle'] ?? 'Unknown Task';
      final taskId = payload['taskId'] ?? '';
      final snoozeTime = DateTime.now().add(const Duration(minutes: 5));

      // Schedule a new notification for 5 minutes later
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: ('${taskId}_snooze').hashCode,
          channelKey: 'task_reminders',
          title: '📝 Task Reminder (Snoozed)',
          body: '$taskTitle starts soon!',
          payload: payload,
          category: NotificationCategory.Reminder,
          wakeUpScreen: true,
        ),
        schedule: NotificationCalendar.fromDate(date: snoozeTime),
      );

      print('Reminder snoozed for 5 minutes: $taskTitle');
    } catch (e) {
      print('Error snoozing reminder: $e');
    }
  }

  // Get all scheduled notifications (useful for debugging)
  Future<List<NotificationModel>> getScheduledNotifications() async {
    return await AwesomeNotifications().listScheduledNotifications();
  }

  // Update an existing reminder
  Future<void> updateTaskReminder(NormalTask task, String taskId) async {
    // Cancel existing reminder and schedule new one
    await cancelTaskReminder(taskId);
    await scheduleTaskReminder(task, taskId);
  }
}
