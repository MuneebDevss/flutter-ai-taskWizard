import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_wizard/Features/Shared/Constants/Theme/my_colors.dart';

class HelpingFunctions {
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orangeAccent;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey; // fallback for unknown values
    }
  }

  static String? validator(String? value, String message) {
    if (value == null || value.isEmpty) {
      return message;
    }
    return null;
  }

  static Color getProgressColor(int totalTasks, double percent) {
    if (totalTasks == 0) {
      return Colors.grey;
    }

    if (percent >= 0.8) {
      return const Color(0xFF10B981); // Green
    } else if (percent >= 0.5) {
      return const Color(0xFFF59E0B); // Amber
    } else {
      return const Color(0xFFEF4444); // Red
    }
  }

  static double getTaskProgress({
    required DateTime startTime,
    required int duration,
  }) {
    final now = DateTime.now();
    final endTime = startTime.add(Duration(minutes: duration));

    if (now.isBefore(startTime)) {
      return 0.0;
    } else if (now.isAfter(endTime)) {
      return 100.0;
    } else {
      final totalDuration = endTime.difference(startTime).inSeconds;
      final elapsed = now.difference(startTime).inSeconds;
      return (elapsed / totalDuration * 100).clamp(0, 100);
    }
  }

  static void showConfirmedStateSnackbar(BuildContext context, String message) {
     if (context.mounted) {
       final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: MYColors.bgGreenColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
     }
  }

  static void showRejectedStateSnackbar(BuildContext context, String message) {
    if (context.mounted) {
      final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: MYColors.errorColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static void pushOnePage(context, page) {
     if (context.mounted) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => page));
     }
  }

  static User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  static void removeAllPrevPagesAndPush(context, page) {
     if (context.mounted) {
       Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => page),
      (Route<dynamic> route) => false, // remove all previous routes
    );
     }
  }

  static String getDayName(int day) {
    const Map<int,String> dayNames = {
      1: 'Mon',
      2: 'Tue',
      3: 'Wed',
      4: 'Thu',
      5: 'Fri',
      6: 'Sat',
      7: 'Sun',
    };
    return dayNames[1]??'Mon';
  }
}
