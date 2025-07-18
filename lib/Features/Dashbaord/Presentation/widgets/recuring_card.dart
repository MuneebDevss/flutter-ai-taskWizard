import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int progressPercentage;
  final List<Color> avatarColors;
  final List<String> avatarInitials;
  final Gradient gradient;
  final String? dueDate;
  final bool isLarge;

  const ProjectCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progressPercentage,
    required this.avatarColors,
    required this.avatarInitials,
    required this.gradient,
    this.dueDate,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header with icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          // Bottom section with avatars and progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Team avatars
              Row(
                children: [
                  ...List.generate(
                    avatarColors.length,
                    (index) => Container(
                      margin: EdgeInsets.only(right: index < avatarColors.length - 1 ? 4 : 0),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: avatarColors[index],
                        child: Text(
                          avatarInitials[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (avatarColors.length > 3)
                    Container(
                      margin: const EdgeInsets.only(left: 4),
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: Text(
                          '+${avatarColors.length - 3}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Progress section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '$progressPercentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Progress bar
              Container(
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progressPercentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              
              // Due date (if provided)
              if (dueDate != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Due: $dueDate',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}