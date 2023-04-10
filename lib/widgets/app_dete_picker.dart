import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<DateTime?> showAppDatePicker(
    {required BuildContext context, DateTime? initialDate}) {
  return DatePicker.showDatePicker(
    context,
    currentTime: initialDate,
    theme: DatePickerTheme(
        containerHeight: 268.h,
        cancelStyle: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFFFFAA00),
        ),
        doneStyle: TextStyle(
          fontSize: 16.sp,
          color: const Color(0xFFFFAA00),
        ),
        itemHeight: 42.h,
        itemStyle: TextStyle(fontSize: 16.sp)),
  );
}
