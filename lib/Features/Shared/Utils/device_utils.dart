import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DeviceUtils {
  static void hideKeyboard (BuildContext context) {

  FocusScope.of(context).requestFocus (FocusNode());
  }
  static Size getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
  static Future<void> setStatusBarColor (Color color) async {

  SystemChrome.setSystemUIOverlayStyle(

  SystemUiOverlayStyle(statusBarColor: color),);}
  static bool isLandscapeOrientation (BuildContext context) {

  final viewInsets = View. of (context).viewInsets;
  return viewInsets.bottom == 0;
  }
  static bool isPortraitOrientation (BuildContext context) {

  final viewInsets = View. of (context).viewInsets;
  return viewInsets.bottom != 0;
  }
  static void setFullScreen (bool enable) {

  SystemChrome.setEnabledSystemUIMode (enable? SystemUiMode. immersiveSticky: SystemUiMode.edgeToEdge);
  }
  static double getPixelRatio(BuildContext context)
  {
    return MediaQuery.of(context).devicePixelRatio;
  }
  static double getStatusBarHeight(BuildContext context)
  {
    return kToolbarHeight;
  }
  static double getNavigationHeight(BuildContext context)
  {
    return kBottomNavigationBarHeight;
  }

  //
  static Future<bool> isPhysicalDevice() async {

  return defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  }
  static void vibrate (Duration duration) {
    HapticFeedback.vibrate();
    Future.delayed(duration, () => HapticFeedback.vibrate());
  }
  //
  static Future<void> setPreferredOrientations (List<DeviceOrientation> orientations) async
  { await SystemChrome.setPreferredOrientations(orientations);
  }
  static void hideStatusBar() {

  SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: []);}
  static void showStatusBar() {

  SystemChrome.setEnabledSystemUIMode (SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty; }
    on SocketException catch (_) {
      return false;
    }
  }
  static bool isIOS() {
    return Platform.isIOS;
  }
  static bool isAndroid() {

  return Platform.isAndroid;
  }
//   static void launchUrl(String url) async { if (await canLaunchUrlString(url)) {

//   await launchUrlString(url);
//   } else {
//   }
//   throw 'Could not launch $url';
// }
}