import 'package:alita/R/app_color.dart';
import 'package:alita/pages/user_profile/user_profile_controller.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SetMySignaturePage extends GetView<UserProfileController> {
  const SetMySignaturePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      TextEditingController editingController =
          useTextEditingController(text: controller.user?.signature);
      return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(AppMessage.personalizedSignature.tr),
          backgroundColor: AppColor.scaffoldBackgroundColor,
          actions: [
            Transform.translate(
              offset: Offset(-16.w, 0),
              child: IconButton(
                iconSize: 56.w,
                padding: EdgeInsets.zero,
                onPressed: () {
                  controller
                      .updateUserInfo(signature: editingController.text.trim())
                      .then((value) {
                    Get.back();
                  });
                },
                icon: Container(
                  constraints: BoxConstraints(
                    maxHeight: 24.h,
                    minWidth: 56.w,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColor.blue.withOpacity(.36),
                      borderRadius: BorderRadius.circular(14.r)),
                  child: Text(
                    AppMessage.finish.tr,
                    style: TextStyle(color: AppColor.blue, fontSize: 12.sp),
                  ),
                ),
              ),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 148.h,
              decoration: BoxDecoration(color: AppColor.white),
              child: TextField(
                controller: editingController,
                decoration: InputDecoration(
                  hintText: AppMessage.setMySignatureHint.tr,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
