import 'package:flutter/material.dart';
import 'package:task_wizard/Features/CreateTask/Presentation/Screens/create_task_screen.dart';
import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';

class FloatingAction extends StatelessWidget {
  const FloatingAction({super.key, required this.selectedDate});

  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      isExtended: true,
      onPressed: () {
        showBottomSheet(
          showDragHandle: true,

          context: context,
          builder: (_) => CreateTaskScreen(startDate: selectedDate),
        );
      },
      backgroundColor: MYColors.defautltColor,
      shape: CircleBorder(),
      child: Icon(Icons.add),
    );
  }
}
