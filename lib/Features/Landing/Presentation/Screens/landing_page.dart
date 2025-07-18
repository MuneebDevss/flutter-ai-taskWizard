import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wizard/Features/Landing/Presentation/FetchTaskBlocs/fetch_task_bloc.dart';
import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/Features/Shared/widgets/add_floating_action.dart';
import 'package:task_wizard/Features/Shared/widgets/bottom_nav.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String selectedCategory = 'All';
  List<String> categories = ['All'];
  ScrollController categoryScrollController = ScrollController();

  @override
  void initState() {
    context.read<FetchTaskBloc>().add(GetAllTasksEvent());
    super.initState();
    // Initialize categories and get tasks
    _initializeCategories();
  }

  void _initializeCategories() {
    // This would typically come from your data source
    // For now, using common categories
    categories = [
      'All',
      'Work',
      'Personal',
      'Health',
      'Social',
      'Education',
      'Finance',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavBarFloating(currentPage: 0),
      floatingActionButton: FloatingAction(selectedDate: DateTime.now()),
      appBar: AppBar(
        title: const Text('Tasks'),

        elevation: 0,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildCategorySelector(),
        ),
      ),
      body: BlocBuilder<FetchTaskBloc, FetchTaskState>(
        builder: (context, state) {
          if (state is TaskSuccess<List<NormalTask>>) {
            final tasks = state.data;
            if (tasks.isNotEmpty) {
              final groupedTasks = _groupTasksByTime(tasks);
              return _buildTaskList(groupedTasks);
            } else {
              return const Center(child: Text('No tasks available'));
            }
          } else if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed:
                        () => context.read<FetchTaskBloc>().add(
                          GetTasksByCategoryEvent(selectedCategory),
                        ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No tasks available'));
        },
      ),
    );
  }

  Widget _buildCategorySelector() {
    return BlocBuilder<FetchTaskBloc, FetchTaskState>(
      builder: (BuildContext context, state) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.builder(
            controller: categoryScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category == selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    selectedCategory = category;

                    if (selectedCategory != 'All') {
                      context.read<FetchTaskBloc>().add(
                        GetTasksByCategoryEvent(category),
                      );
                    } else {
                      context.read<FetchTaskBloc>().add(GetAllTasksEvent());
                    }
                  },
                  backgroundColor: Colors.grey.shade100,
                  selectedColor: Colors.blue.shade100,
                  labelStyle: TextStyle(
                    color:
                        isSelected
                            ? Colors.blue.shade800
                            : Colors.grey.shade700,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  side: BorderSide(
                    color: isSelected ? Colors.blue : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTaskList(Map<String, List<NormalTask>> groupedTasks) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (groupedTasks['missed']?.isNotEmpty ?? false)
          _buildTaskSection('Missed', groupedTasks['missed']!, Colors.red),
        if (groupedTasks['today']?.isNotEmpty ?? false)
          _buildTaskSection('Today', groupedTasks['today']!, Colors.blue),
        if (groupedTasks['tomorrow']?.isNotEmpty ?? false)
          _buildTaskSection(
            'Tomorrow',
            groupedTasks['tomorrow']!,
            Colors.orange,
          ),
        if (groupedTasks['thisWeek']?.isNotEmpty ?? false)
          _buildTaskSection(
            'This Week',
            groupedTasks['thisWeek']!,
            Colors.green,
          ),
        if (groupedTasks['thisMonth']?.isNotEmpty ?? false)
          _buildTaskSection(
            'This Month',
            groupedTasks['thisMonth']!,
            Colors.purple,
          ),
        if (groupedTasks['rest']?.isNotEmpty ?? false)
          _buildTaskSection('Later', groupedTasks['rest']!, Colors.grey),
      ],
    );
  }

  Widget _buildTaskSection(String title, List<NormalTask> tasks, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12, top: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${tasks.length}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        ),
        ...tasks.map((task) => _buildTaskCard(task)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildTaskCard(NormalTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MYColors.cardColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getStatusIcon(task.status),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,

                    decoration:
                        task.status == 'completed'
                            ? TextDecoration.lineThrough
                            : null,
                  ),
                ),
              ),
              _getPriorityChip(task.priority),
            ],
          ),
          if (task.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                _formatDateTime(task.startDate),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.timer, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                '${task.duration} min',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              if (task.location != null) ...[
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  task.location!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return const Icon(Icons.check_circle, color: Colors.green, size: 20);
      case 'missed':
        return const Icon(Icons.error, color: Colors.red, size: 20);
      default:
        return Icon(
          Icons.radio_button_unchecked,
          color: Colors.grey[400],
          size: 20,
        );
    }
  }

  Widget _getPriorityChip(String priority) {
    Color color;
    switch (priority) {
      case 'High':
        color = Colors.red;
        break;
      case 'Medium':
        color = Colors.orange;
        break;
      case 'Low':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(priority, style: Theme.of(context).textTheme.bodyLarge),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (taskDate == today) {
      return 'Today ${_formatTime(dateTime)}';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow ${_formatTime(dateTime)}';
    } else if (taskDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday ${_formatTime(dateTime)}';
    } else {
      return '${dateTime.day}/${dateTime.month} ${_formatTime(dateTime)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  bool occursToday(NormalTask task) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (task.recurrence.type == 'None') {
      // Non-recurrent: only if startDate is today
      return DateTime(
            task.startDate.year,
            task.startDate.month,
            task.startDate.day,
          ) ==
          today;
    }

    final recurrence = task.recurrence;
    final start = DateTime(
      task.startDate.year,
      task.startDate.month,
      task.startDate.day,
    );

    switch (recurrence.type) {
      case 'Daily':
        final diff = today.difference(start).inDays;
        return diff >= 0 && diff % recurrence.interval == 0;
      case 'Weekly':
        final diff = today.difference(start).inDays;
        final weeks = diff ~/ 7;
        final isCorrectWeek = diff >= 0 && weeks % recurrence.interval == 0;
        final weekday = today.weekday;
        // If daysOfWeek is empty, default to startDate's weekday
        final days =
            (recurrence.daysOfWeek?.isNotEmpty ?? false)
                ? recurrence.daysOfWeek
                : [start.weekday];
        return isCorrectWeek && days.contains(weekday);
      case 'Monthly':
        final monthsDiff =
            (today.year - start.year) * 12 + (today.month - start.month);
        final isCorrectMonth =
            monthsDiff >= 0 && monthsDiff % recurrence.interval == 0;
        // If daysOfWeek is empty, default to startDate's day
        final days =
            (recurrence.daysOfWeek?.isNotEmpty ?? false)
                ? recurrence.daysOfWeek
                : [start.day];
        return isCorrectMonth && days.contains(today.day);
      case 'Yearly':
        final yearsDiff = today.year - start.year;
        final isCorrectYear =
            yearsDiff >= 0 && yearsDiff % recurrence.interval == 0;
        // If daysOfWeek is empty, default to startDate's day
        final days =
            (recurrence.daysOfWeek?.isNotEmpty ?? false)
                ? recurrence.daysOfWeek
                : [start.day];
        return isCorrectYear &&
            today.month == start.month &&
            days.contains(today.day);
      default:
        return false;
    }
  }

  Map<String, List<NormalTask>> _groupTasksByTime(List<NormalTask> tasks) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final thisWeek = today.add(const Duration(days: 7));
    final thisMonth = DateTime(now.year, now.month + 1, now.day);

    final groups = <String, List<NormalTask>>{
      'missed': [],
      'today': [],
      'tomorrow': [],
      'thisWeek': [],
      'thisMonth': [],
      'rest': [],
    };

    for (final task in tasks) {
      final taskDate = DateTime(
        task.startDate.year,
        task.startDate.month,
        task.startDate.day,
      );

      if (task.status == 'missed' ||
          (taskDate.isBefore(today) && task.status == 'pending')) {
        groups['missed']!.add(task);
      } else if (occursToday(task)) {
        groups['today']!.add(task);
      } else if (DateTime(taskDate.year, taskDate.month, taskDate.day) ==
          tomorrow) {
        groups['tomorrow']!.add(task);
      } else if (taskDate.isBefore(thisWeek)) {
        groups['thisWeek']!.add(task);
      } else if (taskDate.isBefore(thisMonth)) {
        groups['thisMonth']!.add(task);
      } else {
        groups['rest']!.add(task);
      }
    }

    return groups;
  }

  @override
  void dispose() {
    categoryScrollController.dispose();
    super.dispose();
  }
}
