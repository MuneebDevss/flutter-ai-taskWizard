import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class MYColors {
  static const List bgColors = [
    Color(0xFFFFE7F6),
    Color(0xFFDDFFF1),
    Color(0xFF6C8DFA),
  ];
  static const Map<String, Color> prioritiesColors = {
    'High Priority': Colors.red,
    'Medium Priorty': Colors.yellow,
    'Low Priorty': Colors.blue,
    'No Priorty': Colors.blueGrey,
  };

  static const selectedColor = Colors.blue;
  static const errorColor = Color(0xFFFF6961);
  static const defautltColor = Color(0xFF6C8DFA);
  static const Map<String, Color> emotionColors = {
    'Happy': Color(0xFFFDB0E3), // Light pink
    'Sad': Color(0xFF6C8DFA), // Soft blue
    'Angry': Color(0xFFFF6961), // Coral red
    'Excited': Color(0xFFFFB347), // Pastel orange
    'Calm': Color(0xFF83F5CC), // Mint gre
  };
  static const borderGrey = Color(0xFF404040);

  static const bgGreenColor = Color(0xFF10B981);
  static const greyCardColor = Color(0xFF2D2D2D);
  static Color cardColor(BuildContext context) {
    if (context.isDarkMode) {
      return greyCardColor;
    }
    return Colors.grey.shade100;
  }

  static const List<Color> cardColorList = [
    Color(0xFF8B5CF6), // Purple - Card 1
    Color(0xFF06B6D4), // Cyan - Card 2
    Color(0xFFF59E0B), // Amber - Card 3
    Color(0xFFEF4444), // Red - Card 4 (added)
  ];

  // Alternative vibrant color set
  static const List<Color> alternativeColors = [
    Color(0xFF8B5CF6), // Purple
    Color(0xFF10B981), // Emerald
    Color(0xFFF59E0B), // Amber
    Color(0xFFEC4899), // Pink
  ];

  // Cool tone color set
  static const List<Color> coolTones = [
    Color(0xFFDBD4FD), // Indigo
    Color(0xFFDFFFFA), // Cyan
    Color(0xFF8B5CF6), // Purple
    Color(0xFF10B981), // Emerald
  ];

  // Warm tone color set
  static const List<Color> warmTones = [
    Color(0xFFEF4444), // Red
    Color(0xFFF59E0B), // Amber
    Color(0xFFF97316), // Orange
    Color(0xFFEC4899), // Pink
  ];
  static Color getCategoryColor(int index) {
    final colors = [
      Color(0xFF8B5CF6), // Purple
      Color(0xFF06B6D4), // Cyan
      Color(0xFFF59E0B), // Amber
      Color(0xFFEF4444), // Red
    ];
    return colors[index % colors.length];
  }

  static Color whiteOrGrey(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? Colors.white : Colors.grey;
  }
}

// Usage in your widget:

// Or use it directly in your getCategoryColor method:

// Category Color Palette - Based on your reference design
class CategoryColors {
  // From your reference image
  static const Color mobile = Color(0xFF8B5CF6); // Purple (Mobile)
  static const Color wireframe = Color(0xFF06B6D4); // Cyan (Wireframe)
  static const Color website = Color(0xFFF59E0B); // Amber (Website)

  // Additional fourth color I've added
  static const Color design = Color(0xFFEF4444); // Red (Design)

  // Alternative color options if you need more categories
  static const Color development = Color(0xFF10B981); // Emerald (Development)
  static const Color testing = Color(0xFF8B5CF6); // Violet (Testing)
  static const Color research = Color(0xFF6366F1); // Indigo (Research)
  static const Color deployment = Color(0xFFF97316); // Orange (Deployment)
}

// Usage in your getCategoryColor method:

// Color breakdown with hex values:
/*
1. Mobile (Purple):    #8B5CF6 - RGB(139, 92, 246)
2. Wireframe (Cyan):   #06B6D4 - RGB(6, 182, 212)  
3. Website (Amber):    #F59E0B - RGB(245, 158, 11)
4. Design (Red):       #EF4444 - RGB(239, 68, 68)
*/

// Gradient variations for enhanced effects:
class CategoryGradients {
  static const List<Color> mobile = [
    Color(0xFF8B5CF6), // Primary purple
    Color(0xFF7C3AED), // Darker purple
  ];

  static const List<Color> wireframe = [
    Color(0xFF06B6D4), // Primary cyan
    Color(0xFF0891B2), // Darker cyan
  ];

  static const List<Color> website = [
    Color(0xFFF59E0B), // Primary amber
    Color(0xFFD97706), // Darker amber
  ];

  static const List<Color> design = [
    Color(0xFFEF4444), // Primary red
    Color(0xFFDC2626), // Darker red
  ];
}
