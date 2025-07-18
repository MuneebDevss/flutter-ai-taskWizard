import 'package:flutter/material.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';

import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Utils/extensions.dart';

class TaskCardWithPlaceholders extends StatelessWidget {
  final String title;
  // final String timeRange;
  final String dueDate;
  final int progressPercentage;
  final String priority;
  final List<Color> avatarColors;
  final List<String> avatarInitials;
  final Color priorityColor;
  final String startTime;
  final String endTime;

  const TaskCardWithPlaceholders({
    super.key,
    required this.title,
    // required this.timeRange,
    required this.dueDate,
    required this.progressPercentage,
    required this.priority,
    required this.avatarColors,
    required this.avatarInitials,
    required this.priorityColor,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: Sizes.p4.all,
      padding: Sizes.p20.all,
      decoration: BoxDecoration(
        color: MYColors.greyCardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MYColors.borderGrey, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  priority,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '$progressPercentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(Icons.access_time, color: Color(0xFF9E9E9E), size: 16),
              const SizedBox(width: 8),
              Text(
                '$startTime - $endTime',
                style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Date: $dueDate',
                style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
              ),

              Row(
                children: List.generate(
                  avatarColors.length,
                  (index) => Container(
                    margin: EdgeInsets.only(left: index > 0 ? 4 : 0),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: avatarColors[index],
                      child: Text(
                        avatarInitials[index],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
