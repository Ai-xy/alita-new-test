import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';

abstract class AppTheme {
  static ThemeData lightTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.white,
      iconTheme: IconThemeData(
        color: AppColor.appBarTitleColor,
      ),
      titleTextStyle: TextStyle(
        color: AppColor.appBarTitleColor,
        fontWeight: AppFontWeight.bold,
        fontSize: 20.sp,
      ),
      elevation: 0,
      centerTitle: true,
    ),
    scaffoldBackgroundColor: AppColor.scaffoldBackgroundColor,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColor.accentColor,
    ),
    hintColor: AppColor.hintColor,
    textTheme: TextTheme(
      bodyLarge: AppTextStyle.bodyLarge,
      bodyMedium: AppTextStyle.bodyMedium,
      bodySmall: AppTextStyle.bodySmall,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColor.white,
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      hintStyle: AppTextStyle.hintStyle,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedLabelStyle: TextStyle(fontSize: 0),
      unselectedLabelStyle: TextStyle(fontSize: 0),
      type: BottomNavigationBarType.fixed,
    ),
    dialogTheme: DialogTheme(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
    ),
  );
}
