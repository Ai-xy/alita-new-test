import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/R/app_text_style.dart';
import 'package:alita/pages/forget_password/forget_password_controller.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgetPasswordController>(builder: (_) {
      return Stack(
        children: [
          Image.asset(AppIcon.loginBackground.uri),
          Material(
            color: Colors.transparent,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              children: [
                Gap(188.h),
                AppTextField(
                  prefixIcon: Image.asset(
                    AppIcon.email.uri,
                  ),
                  hintText: AppMessage.email.tr,
                  onChanged: _.setEmail,
                ),
                Gap(16.h),
                AppTextField(
                  prefixIcon: Image.asset(
                    AppIcon.password.uri,
                  ),
                  hintText: AppMessage.password.tr,
                  onChanged: _.setPassword,
                ),
                Gap(16.h),
                AppTextField(
                  prefixIcon: Image.asset(
                    AppIcon.password.uri,
                  ),
                  hintText: AppMessage.enterPasswordAgainHint.tr,
                  onChanged: _.setRePassword,
                ),
                Gap(40.h),
                Container(
                  alignment: Alignment.centerRight,
                  width: double.maxFinite,
                  child: AppButton.withWidget(
                      width: 162.w,
                      color: AppColor.black,
                      onTap: _.resetPassword,
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppMessage.confirm.tr.toUpperCase(),
                            style: AppTextStyle.buttonStyle,
                          ),
                          Image.asset(
                            AppIcon.whiteNext.uri,
                            width: 20.r,
                            height: 20.r,
                          ),
                        ],
                      )),
                ),
              ],
            ),
          ),
          Positioned(
            left: 15.w,
            top: 54.h,
            width: 60.r,
            height: 60.r,
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: Get.back,
                child: Image.asset(
                  AppIcon.back.uri,
                  width: 24.r,
                  height: 24.r,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
