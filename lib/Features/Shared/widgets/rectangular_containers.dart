import 'package:flutter/material.dart';

class RectangularContainer extends StatelessWidget {
  const RectangularContainer({
    super.key,
    required this.hPadding,
    required this.vPadding,
    required this.radius,
    required this.color,
    required this.textString,
    required this.textTheme,
  });
  final double hPadding;
  final double vPadding;
  final double radius;
  final Color color;
  final String textString;
  final TextStyle textTheme;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(textString, style: textTheme),
    );
  }
}