import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppTextStyle {
  static TextStyle bodyLarge = TextStyle(
    fontSize: 16.sp,
    color: AppColor.black,
    fontWeight: AppFontWeight.bold,
  );

  static TextStyle bodyMedium = TextStyle(
    fontSize: 14.sp,
    color: AppColor.black,
  );

  static TextStyle bodySmall = TextStyle(
    fontSize: 12.sp,
    color: AppColor.black,
  );

  static TextStyle hintStyle = TextStyle(
    color: AppColor.hintColor.withOpacity(.5),
    fontSize: 14.sp,
  );
  static TextStyle inputStyle = TextStyle(
    color: AppColor.hintColor,
    fontSize: 14.sp,
  );

  static TextStyle buttonStyle = TextStyle(
    color: AppColor.white,
    fontSize: 16.sp,
  );
  static TextStyle titleStyle = TextStyle(
    fontSize: 18.sp,
    color: AppColor.titleColor,
    fontWeight: AppFontWeight.bold,
  );
}
