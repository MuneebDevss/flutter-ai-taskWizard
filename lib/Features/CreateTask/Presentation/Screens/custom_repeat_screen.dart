import 'package:flutter/material.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/create_task_widgets/frequency_selector_widget.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/create_task_widgets/monthly_date_picker_widget.dart';
import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/recurrence_entity.dart';
import 'package:task_wizard/Features/Shared/Utils/device_utils.dart';
import 'package:task_wizard/Features/Shared/Utils/extensions.dart';

class CustomRepeatScreen extends StatefulWidget {
  const CustomRepeatScreen({
    super.key,
    required this.currentMonth,
    required this.currentDayOfTheMonth,
  });
  final int currentMonth;
  final int currentDayOfTheMonth;
  @override
  State<CustomRepeatScreen> createState() {
    return _CustomRepeatScreen();
  }
}

class _CustomRepeatScreen extends State<CustomRepeatScreen> {
  final Recurrence _recurrence=Recurrence()..daysOfWeek=[]..interval=1..type='Daily';  
  int selectedMonth = 1;

  @override
  void initState() {
    _recurrence.daysOfWeek.add(widget.currentDayOfTheMonth);
    selectedMonth = widget.currentMonth;
    super.initState();
  }

  final List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final Map<String, int> daysOfWeekMap = {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  };
  final List<String> months = [
    'Jan',
    'Feb',
    'March',
    'April',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  void _handleFrequencyChange(String frequency) {
    // Defer the setState call to avoid build-time setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _recurrence.type = frequency;
          // Reset selected days when frequency changes
          if (frequency == 'Day') {
            _recurrence.daysOfWeek.clear();
          } else if (frequency == 'Week') {
            _recurrence.daysOfWeek.clear();
            _recurrence.daysOfWeek.add(DateTime.now().weekday);
          } else if (frequency == 'Month') {
            _recurrence.daysOfWeek.clear();
            _recurrence.daysOfWeek.add(widget.currentDayOfTheMonth);
          } else if (frequency == 'Year') {
            _recurrence.daysOfWeek.clear();
            _recurrence.daysOfWeek.add(widget.currentDayOfTheMonth);
          }
        });
      }
    });
  }

  void _handleIntervalChange(int interval) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _recurrence.interval = interval;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context, {
                'recurrence': _recurrence,
              });
            },
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(Sizes.p10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FrequencySelector(
                onNumberChanged: _handleIntervalChange,
                ontypeChanged: _handleFrequencyChange,
                initialFrequency: _recurrence.type,
              ),
              Sizes.spaceBtwSections.h,
              if (_recurrence.type == 'Weekly')
                Wrap(
                  spacing: 8,
                  children:
                      daysOfWeek.map((day) {
                        final selected = _recurrence.daysOfWeek.contains(
                          daysOfWeekMap[day],
                        );
                        return FilterChip(
                          label: Text(day),
                          selected: selected,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _recurrence.daysOfWeek.add(daysOfWeekMap[day]!);
                              } else {
                                _recurrence.daysOfWeek.remove(daysOfWeekMap[day]);
                              }
                            });
                          },
                        );
                      }).toList(),
                )
              else if (_recurrence.type == 'Monthly')
                MonthlyDatePickerWidget(
                  onDaysChanged:
                      (List<int> daysOfWeek) =>
                          _recurrence.daysOfWeek = daysOfWeek,
                )
              else if (_recurrence.type == 'Yearly')
                Container(
                  height: DeviceUtils.getScreenHeight(context) / 2.7,
                  padding: const EdgeInsets.all(Sizes.p8),
                  decoration: BoxDecoration(
                    color: MYColors.greyCardColor,
                    borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            months[selectedMonth - 1],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ), // Fixed index
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedMonth > 1) {
                                      selectedMonth -= 1;
                                    }
                                  });
                                },
                                icon: Icon(Icons.arrow_back_ios),
                              ),
                              Text('$selectedMonth'),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedMonth < 12) {
                                      selectedMonth += 1;
                                    }
                                  });
                                },
                                icon: Icon(Icons.arrow_forward_ios),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Add your monthly date picker here if needed
                      Expanded(
                        child: GridView.count(
                          crossAxisCount: 7,
                          childAspectRatio: 1.0,
                          children: List.generate(
                            {2, 4, 6, 8, 9, 11}.contains(selectedMonth)
                                ? 31
                                : 30,
                            (index) {
                              final day = index + 1;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_recurrence.daysOfWeek.contains(day)) {
                                      _recurrence.daysOfWeek.remove(day);
                                    } else if (_recurrence.daysOfWeek.length != 1) {
                                      _recurrence.daysOfWeek.add(day);
                                    }
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        _recurrence.daysOfWeek.contains(day)
                                            ? Colors.blue
                                            : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      day.toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
