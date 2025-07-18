import 'package:flutter/material.dart';

class Sizes {
  // Padding and margin sizes
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;
  static const double p48 = 48.0;
  static const double p64 = 64.0;

  // Icon sizes
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  // Font sizes
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 18.0;

  // Button sizes
  static const double buttonHeight = 48.0;
  static const double buttonRadius = 12.0;
  static const double buttonWidth = 120.0;
  static const double buttonElevation = 4.0;

  // AppBar height
  static const double appBarHeight = 56.0;

  // Image sizes
  static const double imageThumbSize = 80.0;

  // Default spacing between sections
  static const double defaultSpace = 20.0;
  static const double spaceBtwItems = 16.0;
  static const double spaceBtwSections = 32.0;

  // Border radius
  static const double borderRadiusSm = 4.0;
  static const double borderRadiusMd = 8.0;
  static const double borderRadiusLg = 12.0;

  // Divider height
  static const double dividerHeight = 1.0;

  // Input field sizes
  static const double inputFieldRadius = 12.0;
  static const double inputFieldSpace = 16.0;

  // Card sizes
  static const double cardRadiusLg = 16.0;
  static const double cardRadiusMd = 12.0;
  static const double cardRadiusSm = 10.0;
  static const double cardElevation = 2.0;
  static const double cardHeight = 150;
  static const double cardwidth = 143;
  // Loading indicator size
  static const double loadingIndicatorSize = 36.0;

  // Grid view spacing
  static const double gridViewSpacing = 16.0;

  // Responsive breakpoints (in logical pixels)
  static const double screenMobile = 480;
  static const double screenTablet = 800;
  static const double screenDesktop = 1000;

  static const p10 = 10.0;

  // Helper method for responsive padding/margin
  static EdgeInsets getPadding(
    BuildContext context, {
    double multiplier = 1.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width > screenDesktop) {
      return EdgeInsets.all(p16 * multiplier);
    } else if (width > screenTablet) {
      return EdgeInsets.all(p12 * multiplier);
    } else {
      return EdgeInsets.all(p8 * multiplier);
    }
  }

  static Size getHeroHeaderSize(
    BuildContext context, {
    double multiplier = 1.0,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Size(width, multiplier * height / 4.0);
  }
}
