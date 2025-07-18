import 'package:flutter/material.dart';

import 'custom_themes/app_bar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/check_box_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_button_theme.dart';
import 'custom_themes/outlined_button_theme.dart';
import 'custom_themes/textform_field_theme.dart';
import 'custom_themes/text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,

    textTheme: TTextTheme.lightText,
    chipTheme: TChipTheme.lightChipTheme,

    scaffoldBackgroundColor: Colors.white,
    appBarTheme: TAppBarTheme.lightAppBarTheme,

    checkboxTheme: TCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetThemeData.lightBottomSheetTheme,

    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButton,
    outlinedButtonTheme: ToutlinedButtonTheme.lightOutlinedButtonTheme,

    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.dark,
    primaryColor: Colors.blue,

    textTheme: TTextTheme.darkText,
    chipTheme: TChipTheme.darkChipTheme,

    scaffoldBackgroundColor: Colors.black,
    appBarTheme: TAppBarTheme.darkAppBarTheme,

    checkboxTheme: TCheckboxTheme.darkCheckboxTheme,

    bottomSheetTheme: TBottomSheetThemeData.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButton,
    outlinedButtonTheme: ToutlinedButtonTheme.darkOutlinedButtonTheme,

    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}
