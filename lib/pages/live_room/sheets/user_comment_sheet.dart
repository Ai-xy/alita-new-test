import 'package:alita/R/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LiveCommentSheet extends StatelessWidget {
  const LiveCommentSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (_) {
      return Material(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
          color: AppColor.white,
          child: SizedBox(
            height: 42.h,
            child: TextField(
              autofocus: true,
              onSubmitted: (_) {
                if (Get.isOverlaysOpen) {
                  Get.back();
                }
              },
              onEditingComplete: () {
                if (Get.isOverlaysOpen) {
                  Get.back();
                  Get.close(1);
                }
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderColor),
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderColor),
                    borderRadius: BorderRadius.circular(22.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColor.borderColor),
                    borderRadius: BorderRadius.circular(22.r),
                  )),
            ),
          ),
        ),
      );
    });
  }
}
