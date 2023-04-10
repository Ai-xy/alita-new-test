import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/R/app_text_style.dart';
import 'package:alita/pages/register/register_controller.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(builder: (_) {
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
                  onChanged: _.setEmial,
                  prefixIcon: Image.asset(
                    AppIcon.email.uri,
                  ),
                  hintText: AppMessage.email.tr,
                ),
                Gap(16.h),
                AppTextField(
                  onChanged: _.setPassword,
                  prefixIcon: Image.asset(
                    AppIcon.password.uri,
                  ),
                  hintText: AppMessage.password.tr,
                  obscureText: true,
                ),
                Gap(16.h),
                AppTextField(
                  onChanged: _.setConfirmPassword,
                  prefixIcon: Image.asset(
                    AppIcon.password.uri,
                  ),
                  hintText: AppMessage.enterPasswordAgainHint.tr,
                  obscureText: true,
                ),
                Gap(40.h),
                Container(
                  alignment: Alignment.centerRight,
                  width: double.maxFinite,
                  child: AppButton.withWidget(
                      onTap: _.signUp,
                      width: 162.w,
                      color: AppColor.black,
                      widget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppMessage.signUp.tr.toUpperCase(),
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
