import 'package:flutter/widgets.dart';

extension SizedBoxExtensions on num {
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get w => SizedBox(width: toDouble());
  SizedBox get s => SizedBox(height: toDouble(), width: toDouble());
}
extension PaddingExtensions on num {
  EdgeInsets get all => EdgeInsets.all(toDouble());
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());
}
