import 'package:flutter/material.dart';
import 'package:task_wizard/Features/Dashbaord/Presentation/widgets/task_progress_widget.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';

import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Utils/extensions.dart';
import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';

class DailProgressChip extends StatefulWidget {
  const DailProgressChip({
    super.key,
    required dailyProgressList,
    required this.index,
  }) : _dailyProgressList = dailyProgressList;

  final dynamic _dailyProgressList;
  final int index;

  @override
  State<DailProgressChip> createState() => _DailProgressChipState();
}

class _DailProgressChipState extends State<DailProgressChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end:
          widget._dailyProgressList[widget.index]['tasksCompleted'] == 0.0
              ? 0
              : widget._dailyProgressList[widget.index]['tasksLeft'] /
                  widget._dailyProgressList[widget.index]['tasksCompleted'] *
                  100,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Add subtle glow animation
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Get category color based on category name
  Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return const Color(0xFF393053); // Soft purple
      case 'work':
        return const Color(0xFF2CB67D); // Emerald green
      case 'health':
        return const Color(0xFF3C2A21); // Gold/Amber
      case 'study':
        return const Color(0xFF3B82F6); // Blue
      case 'development':
        return const Color(0xFF22D3EE); // Cyan
      default:
        return const Color(0xFF232946); // Deep blue-gray
    }
  }

  // Get category icon based on category name
  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'health':
        return Icons.favorite_rounded; // Heart icon for health
      case 'personal':
        return Icons.person_rounded; // Person icon for personal
      case 'work':
        return Icons.work_rounded; // Briefcase icon for work
      case 'study':
        return Icons.school_rounded; // Graduation cap icon for study
      default:
        return Icons.task_alt_rounded; // Default task icon
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = getCategoryColor(
      widget._dailyProgressList[widget.index]['category'],
    );
    final categoryIcon = getCategoryIcon(
      widget._dailyProgressList[widget.index]['category'],
    );

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(Sizes.p12)),
            color: categoryColor,
            border: Border.all(
              color: categoryColor.withOpacity(0.18),
              width: 1,
            ),
            boxShadow: [
              // Outer glow
              BoxShadow(
                color: categoryColor.withOpacity(0.13 * _glowAnimation.value),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
              // Inner highlight
              BoxShadow(
                color: Colors.white.withOpacity(0.07),
                blurRadius: 12,
                spreadRadius: -6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: Sizes.p8.all,
          width: Sizes.cardwidth,
          height: Sizes.cardHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with icon and progress circle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category icon with glow
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          categoryColor.withOpacity(0.22),
                          categoryColor.withOpacity(0.08),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: categoryColor.withOpacity(0.22),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(categoryIcon, size: 20),
                  ),

                  // Progress circle
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: categoryColor.withOpacity(0.18),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: Sizes.p32,
                          height: Sizes.p32,
                          child: Stack(
                            children: [
                              // Background circle
                              Container(
                                width: Sizes.p32,
                                height: Sizes.p32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF2A2A2A),
                                ),
                              ),

                              // Progress circle
                              CustomPaint(
                                size: const Size(Sizes.p32, Sizes.p32),
                                painter: CircularProgressPainter(
                                  progress: _animation.value,
                                  progressColor:
                                      HelpingFunctions.getProgressColor(
                                        widget._dailyProgressList[widget
                                            .index]['tasksCompleted'],
                                        widget._dailyProgressList[widget
                                                    .index]['tasksCompleted'] ==
                                                0
                                            ? 0
                                            : widget._dailyProgressList[widget
                                                    .index]['tasksLeft'] /
                                                widget._dailyProgressList[widget
                                                    .index]['tasksCompleted'] *
                                                100,
                                      ),
                                  strokeWidth: 4,
                                ),
                              ),

                              // Percentage text
                              Center(
                                child: Text(
                                  '${(widget._dailyProgressList[widget.index]['tasksCompleted'] == 0 ? 0 : widget._dailyProgressList[widget.index]['tasksLeft'] / widget._dailyProgressList[widget.index]['tasksCompleted'] * 100).round()}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(
                                        color: categoryColor.withOpacity(0.5),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const Spacer(),

              // Category title
              Text(
                widget._dailyProgressList[widget.index]['category'],
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  // color: Colors.black,
                  fontWeight: FontWeight.w700,
                  shadows: [
                    // Shadow(
                    //   color: categoryColor.withOpacity(0.5),
                    //   blurRadius: 4,
                    // ),
                  ],
                ),
              ),

              // Task count
              Text(
                "${(widget._dailyProgressList[widget.index]['tasksCompleted'] + widget._dailyProgressList[widget.index]['tasksLeft'])} Tasks",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: Sizes.p12,
                  fontWeight: FontWeight.w500,
                ),
              ),

              8.h,

              // Status badges
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes.p8,
                      vertical: Sizes.p4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.p12),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF10B981).withOpacity(0.8),
                          const Color(0xFF059669).withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Text(
                      "${widget._dailyProgressList[widget.index]['tasksCompleted']} Completed",
                      style: TextStyle(
                        fontSize: Sizes.p10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  Sizes.p4.w,

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes.p8,
                      vertical: Sizes.p4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.p12),
                      color: MYColors.defautltColor,
                    ),

                    child: Text(
                      "${widget._dailyProgressList[widget.index]['tasksLeft']} Left",
                      style: TextStyle(
                        fontSize: Sizes.p10,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
