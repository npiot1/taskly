import 'package:flutter/material.dart';

class ApplicationColors {
  static const Color DARK_1 = const Color(0xff1e2837);
  static const Color DARK_2 = const Color(0xff2d3e57);
  static const Color DARK_3 = const Color(0xff3f597d);
  static const Color YELLOW = const Color(0xffFFB852);
  static const Color GREY_1 = const Color(0xff9eadc2);
  static const Color GREY_2 = const Color(0xffC8D2E0);
  static const Color WHITE = Colors.white;
  static const Color MINT = const Color(0xff05E7C7);
  static const Color RED = const Color(0xffEB7E6D);
  static const Color GREEN = const Color(0xff89E288);
  static const Color ORANGE = const Color(0xffFF7A00);
  static const Color PURPLE = const Color(0xffE4B2F6);
  static const Color BLUE = const Color(0xff5299FF);
  static const Color BLUE_2 = const Color(0xff3F597D);
}

class ApplicationLayout {
  static bool isPhone = MediaQueryData.fromView(WidgetsBinding.instance.window).size.shortestSide < 600;
  static bool isTablet = MediaQueryData.fromView(WidgetsBinding.instance.window).size.shortestSide > 600;
}