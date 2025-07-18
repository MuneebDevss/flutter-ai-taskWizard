import 'package:flutter/material.dart';

import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';
import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/recurrence_entity.dart';
import 'package:task_wizard/Features/Shared/Utils/extensions.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/Screens/custom_repeat_screen.dart';

class DateDialogueScreen extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime)? onDateSelected;
  final Function(int?) onReminderSet;
  final Function(Recurrence) onRepeatTypeSet;
  const DateDialogueScreen({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.onDateSelected,
    required this.onReminderSet,
    required this.onRepeatTypeSet,
  });

  @override
  State<DateDialogueScreen> createState() => _DateDialogueState();
}

class _DateDialogueState extends State<DateDialogueScreen> {
  late DateTime selectedDate;
  late DateTime currentMonth;
  String selectedRemindertype = 'None';
  Recurrence _recurrence =
      Recurrence()
        ..type = 'None'
        ..interval = 0
        ..daysOfWeek = []
        ..endDate = '';

  final Map<String, int?> reminderTimes = {
    'None': null,
    "10 minutes before": 10,
    "30 minutes before": 30,
    "1 hour before": 60,
    "2 hours before": 120,
    "1 day before": 1440, // 24 * 60
    "2 days before": 2880, // 48 * 60
  };
  late Map<String, Function(DateTime)> repeatMap;
  late List<String> repeatTypes;
  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
    currentMonth = DateTime(selectedDate.year, selectedDate.month, 1);

    repeatTypes = ['None', 'Daily', 'Weekly', 'Monthly', 'Yearly', 'Custom'];

    repeatMap = {
      'None': (_) => 'None',
      'Daily': (_) => 'Daily',
      'Weekly':
          (DateTime day) =>
              'Weekly (${HelpingFunctions.getDayName(day.weekday)})',
      'Monthly': (DateTime day) => 'Monthly (on ${day.day}th day)',
      'Yearly':
          (DateTime day) => 'Yearly (${day.day}th of ${_getMonthName(day)})',
      'Custom': (_) => 'Custom',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Date',
          style: TextStyle(color: Colors.blue, fontSize: 18),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              widget.onDateSelected?.call(selectedDate);
              Navigator.pop(context, selectedDate);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick date selection buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickDateButton(
                  icon: Icons.calendar_today,
                  label: "Today",
                  onTap: () => _selectDate(DateTime.now()),
                ),
                _buildQuickDateButton(
                  icon: Icons.home,
                  label: "Tomorrow",
                  onTap:
                      () => _selectDate(
                        DateTime.now().add(const Duration(days: 1)),
                      ),
                ),
                _buildQuickDateButton(
                  icon: Icons.calendar_month,
                  label: "Next Monday",
                  onTap: () => _selectDate(_getNextMonday()),
                ),
                _buildQuickDateButton(
                  icon: Icons.wb_sunny,
                  label: "Tomorrow\n Morning",
                  onTap:
                      () => _selectDate(
                        DateTime.now().add(const Duration(days: 1)),
                      ),
                ),
              ],
            ),
          ),

          // Calendar
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Month navigation
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getMonthName(currentMonth),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Colors.white,
                            ),
                            onPressed: () => _previousMonth(),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Colors.white,
                            ),
                            onPressed: () => _nextMonth(),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Calendar grid
                  Expanded(child: _buildCalendarGrid()),
                ],
              ),
            ),
          ),

          // Bottom options
          Container(
            margin: const EdgeInsets.all(Sizes.p8),
            padding: const EdgeInsets.all(Sizes.p8),
            child: Column(
              children: [
                InkWell(
                  onTap: () async {
                    // Handle time selection
                    final TimeOfDay selectedTime =
                        await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                            widget.initialDate,
                          ),
                        ) ??
                        TimeOfDay.now();
                    setState(() {
                      selectedDate = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    });
                  },
                  child: _buildOptionRow(
                    icon: Icons.access_time,
                    title: "Time",
                    value: "${selectedDate.hour}:${selectedDate.minute}",
                  ),
                ),
                const SizedBox(height: 16),
                PopupMenuButton<String>(
                  onSelected: (String key) {
                    setState(() {
                      selectedRemindertype = key;
                    });
                    widget.onReminderSet(reminderTimes[key]);
                  },
                  itemBuilder: (BuildContext context) {
                    return reminderTimes.keys.map((key) {
                      return PopupMenuItem<String>(
                        value: key,
                        child: Text(key),
                      );
                    }).toList();
                  },
                  child: _buildOptionRow(
                    icon: Icons.alarm,
                    title: "Reminder",
                    value:
                        reminderTimes[selectedRemindertype] == null
                            ? 'None'
                            : selectedRemindertype,
                  ),
                ),
                const SizedBox(height: 16),
                PopupMenuButton<String>(
                  onSelected: (String key) async {
                    if (key == 'Custom') {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CustomRepeatScreen(
                                currentMonth: selectedDate.month,
                                currentDayOfTheMonth: selectedDate.day,
                              ),
                        ),
                      );
                      if (result != null && result is Map) {
                        setState(() {
                          _recurrence = result['recurrence'];
                        });
                        widget.onRepeatTypeSet(_recurrence);
                      }
                    } else {
                      setState(() {
                        _recurrence.type = key;
                        _recurrence.interval = 1;
                        _recurrence.daysOfWeek = [];
                        
                      });
                      widget.onRepeatTypeSet(_recurrence);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return repeatTypes.map((key) {
                      final label =
                          repeatMap[key]?.call(selectedDate) ?? 'Unknown';
                      return PopupMenuItem<String>(
                        value: key,
                        child: Text(label),
                      );
                    }).toList();
                  },
                  child: _buildOptionRow(
                    icon: Icons.repeat,
                    title: "Repeat",
                    value:
                        repeatMap[_recurrence.type]?.call(selectedDate) ??
                        'Unknown',
                  ),
                ),
              ],
            ),
          ),
          Sizes.spaceBtwSections.h,
        ],
      ),
    );
  }

  Widget _buildQuickDateButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue, size: Sizes.p32),
            const SizedBox(height: Sizes.p4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final lastDayOfMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    );
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6 weeks * 7 days
      itemBuilder: (context, index) {
        final row = index ~/ 7;

        if (row == 0) {
          // Header row with day names

          return Center(
            child: Text(
              HelpingFunctions.getDayName(index),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          );
        }

        final dayIndex = index - 7;
        // Shift based on firstDayWeekday (1 = Mon, 7 = Sun)
        final dayNumber = dayIndex - (firstDayWeekday - 1) + 1;

        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return Container(); // Empty cell
        }

        final date = DateTime(currentMonth.year, currentMonth.month, dayNumber);
        final isSelected = _isSameDay(date, selectedDate);
        final isToday = _isSameDay(date, DateTime.now());

        return GestureDetector(
          onTap: () => _selectDate(date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                dayNumber.toString(),
                style: TextStyle(
                  color:
                      isSelected
                          ? Colors.white
                          : isToday
                          ? Colors.blue
                          : Colors.white,
                  fontWeight:
                      isSelected || isToday
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              overflow: TextOverflow.fade,
              value,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
          ],
        ),
      ],
    );
  }

  void _selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
      currentMonth = DateTime(date.year, date.month, 1);
    });
  }

  void _previousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    });
  }

  DateTime _getNextMonday() {
    final now = DateTime.now();
    final daysUntilMonday = (8 - now.weekday) % 7;
    return now.add(Duration(days: daysUntilMonday == 0 ? 7 : daysUntilMonday));
  }

  String _getMonthName(DateTime date) {
    const monthNames = [
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
    return monthNames[date.month - 1];
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
