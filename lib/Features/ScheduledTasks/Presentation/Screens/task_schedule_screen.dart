import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:task_wizard/Features/Landing/Presentation/FetchTaskBlocs/fetch_task_bloc.dart';

import 'package:task_wizard/Features/ScheduledTasks/Presentation/Controllers/scheduled_tasks_controllers.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/Features/Shared/widgets/add_floating_action.dart';
import 'package:task_wizard/Features/Shared/widgets/bottom_nav.dart';

class TaskScheduleScreen extends StatefulWidget {
  const TaskScheduleScreen({super.key});

  @override
  State<TaskScheduleScreen> createState() => _TaskScheduleScreenState();
}

class _TaskScheduleScreenState extends State<TaskScheduleScreen> {
  final TaskScheduleController controller = TaskScheduleController();
  @override
  void initState() {
    context.read<FetchTaskBloc>().add(
      GetTasksByDateEvent(controller.selectedDate.value),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBarFloating(currentPage: 1),
      floatingActionButton: FloatingAction(
        selectedDate: controller.selectedDate.value,
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildDatePicker(),
            Expanded(child: SingleChildScrollView(child: _buildTaskSchedule())),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => Row(
              children: [
                Text(
                  _getMonthYearText(controller.selectedDate.value),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB84D),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.grid_view,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        final selectedDate = controller.selectedDate.value;
        final startOfWeek = selectedDate.subtract(
          Duration(days: selectedDate.weekday - 1),
        );

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 7,
          itemBuilder: (context, index) {
            final date = startOfWeek.add(Duration(days: index));
            final isSelected =
                date.day == selectedDate.day &&
                date.month == selectedDate.month &&
                date.year == selectedDate.year;

            return GestureDetector(
              onTap: () => controller.updateSelectedDate(date, context),
              child: Container(
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _getDayName(date.weekday),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildTaskSchedule() {
    return BlocConsumer<FetchTaskBloc, FetchTaskState>(
      listener: (context, state) {
        // Handle side effects like showing snackbars, navigation, etc.
        if (state is TaskFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading tasks: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TaskLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TaskFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Failed to load tasks',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Retry loading tasks
                    context.read<FetchTaskBloc>().add(
                      GetTasksByDateEvent(controller.selectedDate.value),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is TaskSuccess<List<NormalTask>>) {
          final tasksForDate = state.data;

          if (tasksForDate.isEmpty) {
            return const Center(
              child: Text(
                'No tasks scheduled for this day',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          // Calculate overall schedule time range
          final firstTask = tasksForDate.first;
          final lastTask = tasksForDate.last;
          final lastTaskEndTime = controller.getEndingTime(
            '${lastTask.startDate.hour}:${lastTask.startDate.minute}',
            lastTask.duration,
          );

          return Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall time range
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "${'${firstTask.startDate.hour}:${lastTask.startDate.minute}'} - ${controller.formatTime(lastTaskEndTime)}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Day indicator
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayName(controller.selectedDate.value.weekday),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            controller.selectedDate.value.day.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        children: _buildTasksWithBreaks(tasksForDate),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        // Default case - should not reach here with proper state management
        return const SizedBox.shrink();
      },
    );
  }

  List<Widget> _buildTasksWithBreaks(List<NormalTask> tasks) {
    List<Widget> widgets = [];

    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];

      // Add task widget
      widgets.add(_buildTaskCard(task));

      // Check if there's a break between this task and the next
      if (i < tasks.length - 1) {
        final currentTaskEnd = _getTaskEndTime(task);
        final nextTaskStart = _getTaskStartTime(tasks[i + 1]);

        if (currentTaskEnd.isBefore(nextTaskStart)) {
          widgets.add(_buildBreakCard(currentTaskEnd, nextTaskStart));
        }
      }
    }

    return widgets;
  }

  Widget _buildTaskCard(NormalTask task) {
    final String startTime = '${task.startDate.hour}:${task.startDate.minute}';
    final endTime = controller.getEndingTime(startTime, task.duration);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$startTime - ${controller.formatTime(endTime)}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            task.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildAvatar(Colors.pink, 'A'),
              const SizedBox(width: 4),
              _buildAvatar(Colors.orange, 'B'),
              if (task.collaboration.sharedWith.length > 2)
                Container(
                  margin: const EdgeInsets.only(left: 4),
                  child: _buildAvatar(
                    Colors.red,
                    '+${task.collaboration.sharedWith.length - 2}',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBreakCard(DateTime startTime, DateTime endTime) {
    
    

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Break",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${controller.formatTime("${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}")} - ${controller.formatTime("${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}")}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(Color color, String text) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  DateTime _getTaskStartTime(NormalTask task) {
    return DateTime(0, 1, 1, task.startDate.hour, task.startDate.minute);
  }

  DateTime _getTaskEndTime(NormalTask task) {
    final startTime = _getTaskStartTime(task);
    return startTime.add(Duration(minutes: task.duration));
  }

  String _getMonthYearText(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return "${months[date.month - 1]} ${date.year}";
  }

  String _getDayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}
