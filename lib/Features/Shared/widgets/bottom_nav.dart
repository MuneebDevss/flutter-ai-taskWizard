import 'package:flutter/material.dart';

import 'package:task_wizard/Features/Shared/Utils/helping_functions.dart';
import 'package:task_wizard/bindings.dart';

void _handleNavigation(BuildContext context, int index) {
  final routes = [
    '/home', // 0 - Home
    '/calendar', // 1 - Calendar
    '/Chatbot', // 2 - Chat
    '/profile', // 3 - Profile
  ];
  final bindingsMap = {'/Chatbot': ChatbotBinding()};
  if (index < routes.length) {
    if (bindingsMap.containsKey(routes[index])) {
      // Manually initialize the binding
      ChatbotBinding().dependencies();
    }

    if (routes[index] != '/profile') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routes[index],
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        routes[index],
        (Route<dynamic> route) => false,
        arguments: HelpingFunctions.getCurrentUser()?.uid ?? '',
      );
    }
  }
}

// Navigate to the selected page

// Alternative version with floating action button style for active item
class CustomBottomNavBarFloating extends StatelessWidget {

  const CustomBottomNavBarFloating({super.key, required this.currentPage});
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,

      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade800,
            blurRadius: 4,

            blurStyle: BlurStyle.normal,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home', context),
          _buildNavItem(
            1,
            Icons.calendar_today_outlined,
            Icons.calendar_today,
            'Calendar',
            context,
          ),
          _buildNavItem(
            2,
            Icons.chat_bubble_outline,
            Icons.chat_bubble,
            'Chatbot',
            context,
          ),
          _buildNavItem(
            3,
            Icons.person_outline,
            Icons.person,
            'Profile',
            context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData outlinedIcon,
    IconData filledIcon,
    String label,
    BuildContext context,
  ) {
    final isSelected = currentPage == index;

    return GestureDetector(
      onTap: () => _handleNavigation(context, index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container with floating animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow:
                    isSelected
                        ? [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                        : [],
              ),
              child: Icon(
                isSelected ? filledIcon : outlinedIcon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.blue : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CustomBottomNavBar extends StatefulWidget {
//   const CustomBottomNavBar({super.key});

//   @override
//   State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   late Widget currentScreen;
//   late int selectedIndex;
//   @override
//   void initState() {
//     currentScreen = DashboardPage();
//     selectedIndex = 0;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           currentScreen,
//           Positioned(
//             left: 0,
//             right: 0,
//             bottom: 0,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.7),
//                     blurRadius: 20,
//                     spreadRadius: Sizes.p16,
//                     offset: Offset(0, 10),
//                   ),
//                 ],
//               ),
//               height: 90,
//               child: Stack(
//                 children: [
//                   // Custom clipped navigation bar
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: RepaintBoundary(
//                       child: ClipPath(
//                         clipper: CustomBottomNavClipper(),
//                         child: Container(
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Color(0xFF2A2A2A),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withOpacity(0.3),
//                                 blurRadius: 20,
//                                 offset: Offset(0, -5),
//                               ),
//                             ],
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               _buildNavItem(Icons.home_outlined, 0),
//                               _buildNavItem(Icons.calendar_today_outlined, 1),
//                               SizedBox(width: 60), // Space for floating button
//                               _buildNavItem(Icons.chat_bubble_outline, 2),
//                               _buildNavItem(Icons.person_outline, 3),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Floating add button
//                   Positioned(
//                     top: 0,
//                     left: MediaQuery.of(context).size.width / 2 - 30,
//                     bottom: Sizes.p24,
//                     child: Container(
//                       width: 60,
//                       height: 60,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [Color(0xFFF4C2A1), Color(0xFFE8A87C)],
//                         ),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: Color(0xFFF4C2A1).withOpacity(0.3),
//                             blurRadius: 15,
//                             offset: Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(30),
//                           onTap:
//                               () => setState(() {
//                                 selectedIndex = 2;
//                                 currentScreen = _getScreenForIndex(
//                                   selectedIndex,
//                                 );
//                               }),
//                           child: Icon(
//                             Icons.add,
//                             color: Color(0xFF2A2A2A),
//                             size: 28,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, int index) {
//     bool isSelected = selectedIndex == index;
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedIndex = index;
//           currentScreen = _getScreenForIndex(index);
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         child: Icon(
//           icon,
//           color: isSelected ? Colors.white : Colors.grey,
//           size: 24,
//         ),
//       ),
//     );
//   }

//   Widget _getScreenForIndex(int index) {
//     switch (index) {
//       case 0:
//         return const DashboardPage();
//       case 1:
//         return TaskScheduleScreen(); // Replace with actual screen
//       case 2:
//         return const CreateTaskScreen(); // Replace with actual screen
//       // case 3:
//       // return ChatPage(); // Replace with actual screen
//       // case 4:
//       // return ProfilePage(); // Replace with actual screen
//       default:
//         return const DashboardPage();
//     }
//   }
// }

// class BottomNavBarClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     final curveHeight = 20.0;
//     final curveWidth = 40.0;

//     path.lineTo(0, size.height - curveHeight);

//     // Left curve
//     path.quadraticBezierTo(
//       size.width * 0.25,
//       size.height,
//       size.width * 0.5 - curveWidth,
//       size.height - curveHeight,
//     );

//     // Center dip
//     path.quadraticBezierTo(
//       size.width * 0.5,
//       size.height - curveHeight * 1.5,
//       size.width * 0.5 + curveWidth,
//       size.height - curveHeight,
//     );

//     // Right curve
//     path.quadraticBezierTo(
//       size.width * 0.75,
//       size.height,
//       size.width,
//       size.height - curveHeight,
//     );

//     path.lineTo(size.width, 0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }

// // Alternative simpler clipper if you prefer cleaner edges
// class CustomBottomNavClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     double width = size.width;
//     double height = size.height;

//     final path = Path();
//     path.moveTo(0, 0);
//     path.lineTo(width * 0.25, 0);

//     path.lineTo(width * 0.35, 0);

//     path.quadraticBezierTo(width * 0.40, 0, width * 0.42, 20);

//     path.arcToPoint(
//       Offset(width * 0.58, 20),
//       radius: const Radius.circular(20),
//       clockwise: false,
//     );

//     path.quadraticBezierTo(width * 0.60, 0, width * 0.65, 0);

//     path.lineTo(width, 0);
//     path.lineTo(width, height);
//     path.lineTo(0, height);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
