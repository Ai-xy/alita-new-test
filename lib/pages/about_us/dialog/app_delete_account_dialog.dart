import 'package:alita/R/app_color.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

Future showAppDeleteAccountDialog({required Function() onDeleteAccount}) {
  return Get.dialog(AppDeleteAccountDialog(onDeleteAccount: onDeleteAccount));
}

class AppDeleteAccountDialog extends StatelessWidget {
  final Function() onDeleteAccount;
  const AppDeleteAccountDialog({Key? key, required this.onDeleteAccount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(46.h),
            Text(
              AppMessage.deleteAccountTip.tr,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColor.dialogBodyTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(36.h),
            Row(
              children: [
                Expanded(
                  child: AppButton.gray(
                    onTap: Get.back,
                    text: AppMessage.cancel.tr,
                    height: 40.h,
                  ),
                ),
                Gap(14.w),
                Expanded(
                  child: AppButton(
                    onTap: () {
                      Future(() {
                        return onDeleteAccount();
                      }).then((value) {
                        Get.back();
                      });
                    },
                    text: AppMessage.confirm.tr,
                    height: 40.h,
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      color: AppColor.white,
                    ),
                  ),
                ),
              ],
            ),
            Gap(36.h),
          ],
        ),
      ),
    );
  }
}
