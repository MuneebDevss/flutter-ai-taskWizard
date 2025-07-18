import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/Controllers/create_task_controller.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/CreateTaskBlocs/create_task_bloc.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/CreateTaskBlocs/create_task_bloc_state.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/Services/notifications_controller.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/create_task_widgets/date_dialogue_widget.dart';

import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';
import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/collaboration_enitiy.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/normal_task_entity.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/recurrence_entity.dart';
import 'package:task_wizard/Features/Shared/Data/Entities/reminder_entity.dart';

import 'package:task_wizard/Features/Shared/Utils/extensions.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';

class CreateTaskScreen extends StatefulWidget {
  final DateTime? startDate;
  const CreateTaskScreen({super.key, this.startDate});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _newCategoryController = TextEditingController();
  final CreateTaskController _controller = CreateTaskController(
    reminderScheduler: NotificationsController(),
  );

  String _selectedCategory = 'Work';
  int? reminderMinutes;
  Recurrence repeat =
      Recurrence()
        ..type = 'None'
        ..interval = 0
        ..daysOfWeek = []
        ..endDate = '';
  String _selectedPriority = 'Medium';
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.startDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _newCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocListener<AddTaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskSuccess) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Task created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is TaskFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: Theme.of(context).inputDecorationTheme.border!
                      .copyWith(borderSide: BorderSide.none),
                ),
                validator:
                    (value) =>
                        HelpingFunctions.validator(value, 'Title is required'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: Theme.of(context).inputDecorationTheme.border!
                      .copyWith(borderSide: BorderSide.none),
                ),
                validator:
                    (value) => HelpingFunctions.validator(
                      value,
                      'Description is required',
                    ),
              ),
              Sizes.p16.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopupMenuButton(
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(),
                    child: Chip(
                      shadowColor: MYColors.greyCardColor,
                      shape: StadiumBorder(),

                      label: Text(_selectedCategory),
                    ),
                    itemBuilder:
                        (_) =>
                            _controller.categories
                                .map(
                                  (cat) => PopupMenuItem(
                                    onTap: () {
                                      if (cat == 'Create New') {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (_) => AlertDialog(
                                                title: const Text(
                                                  'Create New Category',
                                                ),
                                                content: TextField(
                                                  controller:
                                                      _newCategoryController,
                                                  decoration:
                                                      const InputDecoration(
                                                        hintText:
                                                            'Enter category name',
                                                      ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: const Text('Cancel'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      final newCat =
                                                          _newCategoryController
                                                              .text
                                                              .trim();
                                                      if (newCat.isNotEmpty) {
                                                        setState(() {
                                                          _controller.categories
                                                              .add(newCat);
                                                          _selectedCategory =
                                                              newCat;
                                                        });
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      }
                                                    },
                                                    child: const Text('Create'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      } else {
                                        setState(() {
                                          _selectedCategory = cat;
                                        });
                                      }
                                    },
                                    child: Text(
                                      cat,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium!.copyWith(
                                        color:
                                            cat == _selectedCategory ||
                                                    cat == 'Create New'
                                                ? MYColors.selectedColor
                                                : Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium!.color,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                  ),
                  IconButton(
                    onPressed: () => showDatePicker(context),
                    icon: const Icon(Icons.calendar_today),
                  ),
                  PopupMenuButton(
                    icon: Icon(
                      Icons.flag,
                      color: MYColors.prioritiesColors[_selectedPriority],
                    ),
                    itemBuilder: (BuildContext context) {
                      return _controller.priorities
                          .map(
                            (String priority) => PopupMenuItem(
                              value: priority,
                              onTap: () => _selectedPriority = priority,
                              child: ListTile(
                                leading: Icon(
                                  Icons.flag,
                                  color: MYColors.prioritiesColors[priority],
                                ),
                                trailing: Text(
                                  priority,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ),
                          )
                          .toList();
                    },
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: const Icon(Icons.tag),
                  // ),
                  OutlinedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? true) {
                        _controller.addTask(
                          context,
                          NormalTask(
                            status: 'pending',
                            title: _titleController.text,
                            description: _descriptionController.text,
                            category: _selectedCategory,
                            priority: _selectedPriority,
                            startDate: _selectedDate,
                            duration: 15,
                            recurrence: repeat,
                            reminders:
                                reminderMinutes == null
                                    ? []
                                    : [
                                      Reminder()
                                        ..type = repeat.type
                                        ..minutesBefore = reminderMinutes!,
                                    ],
                            collaboration:
                                Collaboration()
                                  ..isShared = false
                                  ..sharedWith = [],
                            id: '',
                            notes: '',
                          ),
                        );
                      }
                    },
                    label: Icon(Icons.send),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showDatePicker(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DateDialogueScreen(
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onReminderSet: (int? minutes) {
                reminderMinutes = minutes;
              },
              onDateSelected: (DateTime selectedDate) {
                _selectedDate = selectedDate;
              },
              onRepeatTypeSet: (Recurrence val) {
                repeat = val;
              },
            ),
      ),
    );
  }
}
