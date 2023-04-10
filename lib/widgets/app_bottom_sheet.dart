import 'package:alita/R/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppBottomSheet extends StatelessWidget {
  final Widget child;
  const AppBottomSheet({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r), topRight: Radius.circular(30.r)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.white,
        ),
        constraints: BoxConstraints(
          maxHeight: Get.height * .5,
          minHeight: 210.h,
        ),
        child: child,
      ),
    );
  }
}
