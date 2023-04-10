import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

abstract class AppToast {
  static CancelFunc loading() {
    return BotToast.showCustomLoading(
        backgroundColor: Colors.black.withOpacity(.5),
        toastBuilder: (void Function() cancelFunc) {
          return HookBuilder(builder: (context) {
            final AnimationController animationController =
                useAnimationController(duration: const Duration(seconds: 1))
                  ..repeat();
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RotationTransition(
                    turns: animationController,
                    child: Image.asset(
                      AppIcon.loading.uri,
                      width: 72.r,
                      height: 72.r,
                    ),
                  ),
                  Gap(13.h),
                  Text(
                    AppMessage.loading.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.white,
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  static CancelFunc alert({required String message}) {
    return BotToast.showCustomNotification(
      enableSlideOff: false,
      align: Alignment.center,
      duration: const Duration(seconds: 2),
      wrapToastAnimation: (controller, onClose, child) {
        return FadeTransition(
          opacity: controller,
          child: child,
        );
      },
      animationDuration: const Duration(milliseconds: 200),
      toastBuilder: (void Function() cancelFunc) {
        return Container(
          transform: Matrix4.translationValues(0, -16.r, 0),
          constraints: BoxConstraints(minHeight: 45.r),
          margin: EdgeInsets.symmetric(horizontal: 36.r),
          padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 15.r),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.black.withOpacity(0.6)),
          child: Text(
            message,
            style: TextStyle(fontSize: 15.sp, color: AppColor.white),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
