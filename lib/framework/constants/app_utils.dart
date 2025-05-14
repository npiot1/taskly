import 'package:flutter/material.dart';

class ApplicationColors {
  static const Color MAIN_COLOR = Colors.deepPurple;
  static const Color DARK_1 = const Color(0xff1e2837);
  static const Color GREY_2 = const Color(0xffC8D2E0);
  static const Color WHITE = Colors.white;
  static const Color ORANGE = const Color(0xffFF7A00);
}

class ApplicationLayout {
  static bool isPhone = MediaQueryData.fromView(WidgetsBinding.instance.window).size.shortestSide < 600;
  static bool isTablet = MediaQueryData.fromView(WidgetsBinding.instance.window).size.shortestSide > 600;
}