import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:task_wizard/Features/Shared/Constants/app_sizes.dart';

import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';
import 'package:task_wizard/Features/Shared/Utils/extensions.dart';
import 'package:task_wizard/Features/Shared/widgets/rectangular_containers.dart';

class TaskProgressWidget extends StatefulWidget {
  final String title;
  final int completedTasks;
  final int totalTasks;
  final String date;
  final Color progressColor;
  final Color backgroundColor;
  final Color dateTagColor;

  const TaskProgressWidget({
    super.key,
    this.title = 'Task Progress',
    required this.completedTasks,
    required this.totalTasks,
    this.date = 'March 22',
    this.progressColor = const Color(0xFF4A90E2),
    this.backgroundColor = const Color(0xFF2D2D2D),
    this.dateTagColor = const Color(0xFF4A90E2),
  });

  @override
  State<TaskProgressWidget> createState() => _TaskProgressWidgetState();
}

class _TaskProgressWidgetState extends State<TaskProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

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
          widget.totalTasks == 0.0
              ? 0.0
              : widget.completedTasks / widget.totalTasks,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MYColors.borderGrey, width: 1),
      ),
      child: Row(
        children: [
          // Left side content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Sizes.p4.h,
                // Task count
                Text(
                  '${widget.completedTasks}/${widget.totalTasks} task done',
                  style: const TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 14,
                  ),
                ),

                Sizes.p8.h,

                // Date tag
                RectangularContainer(
                  hPadding: Sizes.p12,
                  vPadding: Sizes.p8 - 1,
                  radius: Sizes.p12,
                  color: widget.dateTagColor,
                  textString: widget.date,
                  textTheme: Theme.of(context).textTheme.labelMedium!,
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Right side - Circular progress
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                width: Sizes.p64,
                height: Sizes.p64,
                child: Stack(
                  children: [
                    // Background circle
                    Container(
                      width: Sizes.p64,
                      height: Sizes.p64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF404040),
                      ),
                    ),

                    // Progress circle
                    CustomPaint(
                      size: const Size(Sizes.p64, Sizes.p64),
                      painter: CircularProgressPainter(
                        progress: _animation.value,
                        progressColor: widget.progressColor,
                        strokeWidth: 6,
                      ),
                    ),

                    // Percentage text
                    Center(
                      child: Text(
                        '${(widget.totalTasks == 0 ? 0 : widget.completedTasks / widget.totalTasks * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.progressColor,
    this.strokeWidth = 6,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw progress arc
    final progressPaint =
        Paint()
          ..color = progressColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2; // Start from top
    final sweepAngle = 2 * math.pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
