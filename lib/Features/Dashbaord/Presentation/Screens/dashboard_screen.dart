import 'package:flutter/material.dart';
import 'package:task_wizard/Features/Dashbaord/Presentation/Controllers/dashboard_controller.dart';
import 'package:task_wizard/Features/Dashbaord/Presentation/widgets/daily_tasks.dart';
import 'package:task_wizard/Features/Dashbaord/Presentation/widgets/recuring_card.dart';
import 'package:task_wizard/Features/Dashbaord/Presentation/widgets/taskCard_widget.dart';
import 'package:task_wizard/Features/Dashbaord/Presentation/widgets/task_progress_widget.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';

import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Utils/device_utils.dart';
import 'package:task_wizard/Features/Shared/Utils/extensions.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

String _monthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[month - 1];
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  final DashboardController _dashboardController = DashboardController();
  @override
  void initState() {
    super.initState();
    _dashboardController.getProgressSummary();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: Sizes.p16.all,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello,',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextSpan(text: ' ${_dashboardController.user.userName}'),
                    ],
                  ),
                ),
                Sizes.spaceBtwItems.h,
                SizedBox(
                  width: DeviceUtils.getScreenWidth(context) / 1.5,
                  child: Text(
                    'Let\'s be productive today',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                Sizes.spaceBtwItems.h,
                // Task Progress Widget
                TaskProgressWidget(
                  title: 'Task Progress',
                  completedTasks: _dashboardController.currentCompletedTasks,
                  totalTasks: _dashboardController.totalCurrentTasks,
                  date: _formattedToday(),
                  progressColor: _dashboardController.progressColor,
                  dateTagColor: MYColors.bgGreenColor,
                ),
                Sizes.spaceBtwSections.h,
                Text(
                  'Daily Tasks',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Sizes.spaceBtwItems.h,
                DailyProgressSection(
                  dailyProgressList:
                      _dashboardController.getTopCategoryProgress(),
                ),
                Sizes.spaceBtwSections.h,
                Text(
                  'On going tasks',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Sizes.spaceBtwItems.h,

                OngoingTasks(
                  ongoingTasks: _dashboardController.getOngoingTasks(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formattedToday() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')} ${_monthName(now.month)} ${now.year}";
  }
}

String getEndingTime(String taskTime, int duration) {
  final parts = taskTime.split(':');
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);

  final startTime = DateTime(0, 1, 1, hour, minute);
  final endTime = startTime.add(Duration(minutes: duration));

  return "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";
}

class OngoingTasks extends StatelessWidget {
  const OngoingTasks({super.key, required this.ongoingTasks});
  final List ongoingTasks;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        if (index >= ongoingTasks.length) {
          // If there are fewer than 5 tasks, show a placeholder or empty space
          return const SizedBox.shrink();
        }
        final task = ongoingTasks[index];
        // Safe conversion of timestamp to DateTime
        DateTime? startDateTime;
        final startDate = task.startDate;
        try {
          if (startDate == null) {
            startDateTime = DateTime.now();
          } else if (startDate is DateTime) {
            startDateTime = startDate;
          } else {
            startDateTime =
                DateTime.tryParse(startDate.toString()) ?? DateTime.now();
          }
        } catch (e) {
          print('Error converting startDate for task $index: $e');
          startDateTime = DateTime.now(); // fallback to current time
        }

        // Calculate progress with error handling
        int progressPercentage = 0;
        try {
          final duration = (task.duration is int) ? task.duration : 60;
          progressPercentage =
              getTaskProgress(
                duration: duration, // default 60 minutes
                startTime: startDateTime,
              ).toInt();
        } catch (e) {
          print('Error calculating progress for task $index: $e');
          progressPercentage = 0;
        }

        // Format due date from startDateTime
        String dueDateStr;
        dueDateStr = "${startDateTime.day.toString().padLeft(2, '0')} ${_monthName(startDateTime.month)} ${startDateTime.year}";
      
        // Compute start and end time strings
        String startTimeStr = task.time ?? '--:--';
        String endTimeStr = getEndingTime(
          task.time ?? '00:00',
          (task.duration is int) ? task.duration : 60,
        );

        return TaskCardWithPlaceholders(
          title: task.title ?? 'Untitled Task',
          dueDate: dueDateStr,
          progressPercentage: progressPercentage,
          priority: task.priority ?? 'Medium',
          priorityColor: HelpingFunctions.getPriorityColor(
            task.priority ?? 'Medium',
          ),
          avatarColors: [Colors.pink, Colors.blue],
          avatarInitials: ['A', 'B'],
          startTime: startTimeStr,
          endTime: endTimeStr,
        );
      }),
    );
  }
}

// Enhanced getTaskProgress with better error handling
double getTaskProgress({required DateTime startTime, required int duration}) {
  try {
    final now = DateTime.now();
    final endTime = startTime.add(Duration(minutes: duration));

    // Check if the dates are valid
    if (startTime.isAfter(DateTime(2100)) ||
        startTime.isBefore(DateTime(2020))) {
      print('Warning: startTime seems invalid: $startTime');
      return 0.0;
    }

    if (now.isBefore(startTime)) {
      return 0.0;
    } else if (now.isAfter(endTime)) {
      return 100.0;
    } else {
      final totalDuration = endTime.difference(startTime).inSeconds;
      final elapsed = now.difference(startTime).inSeconds;

      if (totalDuration <= 0) {
        return 100.0; // Task with no duration is considered complete
      }

      return (elapsed / totalDuration * 100).clamp(0, 100);
    }
  } catch (e) {
    print('Error in getTaskProgress: $e');
    return 0.0;
  }
}

class DailyProgressSection extends StatefulWidget {
  const DailyProgressSection({
    super.key,
    required List<Map<String, dynamic>> dailyProgressList,
  }) : _dailyProgressList = dailyProgressList;

  final List<Map<String, dynamic>> _dailyProgressList;
  @override
  State<DailyProgressSection> createState() => _DailyProgressSectionState();
}

class _DailyProgressSectionState extends State<DailyProgressSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DailProgressChip(
            dailyProgressList: widget._dailyProgressList,
            index: 2,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              2,
              (index) => DailProgressChip(
                dailyProgressList: widget._dailyProgressList,
                index: index,
              ),
            ),
          ),
        ),
        Sizes.spaceBtwItems.h,
      ],
    );
  }
}

class RecurringTasks extends StatelessWidget {
  const RecurringTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // UX Design Card (Purple)
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ProjectCard(
                    title: 'UX Design',
                    subtitle: 'Task management mobile app',
                    progressPercentage: 70,
                    avatarColors: [Colors.orange, Colors.pink, Colors.blue],
                    avatarInitials: ['A', 'B', 'C'],
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    ),
                    dueDate: '24 Mar 2022',
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Right column
              Expanded(
                child: Column(
                  children: [
                    // API Payment (Blue)
                    SizedBox(
                      height: 90,
                      child: ProjectCard(
                        title: 'API Payment',
                        subtitle: '',
                        progressPercentage: 40,
                        avatarColors: [Colors.purple, Colors.orange],
                        avatarInitials: ['M', 'J'],
                        gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Update work (Green)
                    SizedBox(
                      height: 90,
                      child: ProjectCard(
                        title: 'Update work',
                        subtitle: 'Revision home page',
                        progressPercentage: 85,
                        avatarColors: [Colors.red],
                        avatarInitials: ['S'],
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
