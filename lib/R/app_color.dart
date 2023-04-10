import 'package:flutter/material.dart';

abstract class AppColor {
  static const Color appBarTitleColor = Color(0xFF343434);
  static const Color bodyTextColor = Color(0xFF333333);
  static const Color bodyText2Color = Color(0xFF202020);
  static Color hintTextColor = const Color(0xFF202020).withOpacity(.5);
  static const Color pink = Color(0xFFFF8DA7);
  static const Color white = Colors.white;
  static const Color blue = Color(0xFF4D82FF);
  static const Color lightBlue = Color(0xFF0098DA);
  static const Color green = Color(0xFF87D660);
  static const Color yellow = Color(0xFFFFAA00);
  static const Color black = Color(0xFF202020);
  static const Color grey = Color(0xFF646363);
  static const Color hintColor = Color(0xFF202020);
  static const Color titleColor = Color(0xFF333333);
  static const Color accentColor = Color(0xFFFEA623);
  static const Color borderColor = Color(0xFF959595);
  static const Color bottomNavigationBarShadowColor =
      Color.fromARGB(25, 0, 0, 0);
  static const Color scaffoldBackgroundColor = Color(0xFFF7F7F7);
  static const Color lightGrey = Color(0xFFAFAFB1);
  static const Color barrierBackgroundColor = Color.fromRGBO(0, 0, 0, 0.5);
  static const Color pinputBackgroundColor = Color(0xFFFFE5BE);
  static const Color pinputBorderColor = Color(0xFFFEA623);
  static const Color dialogTextColor = Color(0xFF333333);
  static const Color primary = Colors.red;
  static const Color tileDividerColor = Color(0xFFE2E2E2);
  static const Color blackButtonColor = Color(0xFF202020);
  static const Color greyButtonColor = Color(0xFFECECED);

  static const Color dialogBodyTextColor = Color(0xFF333333);
  static const Color profileTileValueColor = Color(0xFF7D7D7D);
  static const Color messageBadageColor = Color(0xFFFF325E);
  static const Color chatContentInputTextFieldColor = Color(0xFFF9F9F9);
  static const Color tabbarLabelColor = Color(0xFF343434);
  static const Color textFieldBorderColor = Color(0xFFECECED);
  static const Color selectedBorderColor = Color(0xFFFFAA00);
  static const Color messageBubbleColor = Color(0xFFF9F9F9);
  static const Color messageTextolor = Color(0xFF999999);

  final Color color;
  const AppColor({required this.color});
}
