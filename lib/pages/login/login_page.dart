import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/R/app_text_style.dart';
import 'package:alita/pages/login/login_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_checkbox.dart';
import 'package:alita/widgets/app_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(AppIcon.loginBackground.uri),
        GetBuilder<LoginController>(builder: (_) {
          return Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              child: ListView(
                children: [
                  Gap(76.h),
                  Image.asset(
                    AppIcon.logo.uri,
                    width: 80.r,
                    height: 80.r,
                  ),
                  Gap(13.h),
                  Text(
                    AppMessage.yonoLive.tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bodyLarge,
                  ),
                  Gap(76.h),
                  AppTextField(
                    prefixIcon: Image.asset(
                      AppIcon.email.uri,
                    ),
                    hintText: AppMessage.email.tr,
                    onChanged: _.setEmial,
                  ),
                  Gap(16.h),
                  AppTextField(
                    prefixIcon: Image.asset(
                      AppIcon.password.uri,
                    ),
                    hintText: AppMessage.password.tr,
                    onChanged: _.setPassword,
                    obscureText: true,
                  ),
                  Gap(30.h),
                  AppButton(
                    text: AppMessage.login.tr,
                    color: AppColor.black,
                    onTap: _.login,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Gap(20.h),
                          Text.rich(TextSpan(
                              text: AppMessage.noAccountTip.tr,
                              style: AppTextStyle.bodyMedium,
                              children: [
                                const TextSpan(text: '\t'),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.toNamed(AppPath.register);
                                    },
                                  text: AppMessage.signUp.tr,
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    color: AppColor.pink,
                                  ),
                                )
                              ]))
                        ],
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.toNamed(AppPath.forgetPassword);
                        },
                        child: Text(
                          AppMessage.forgot.tr,
                          style: AppTextStyle.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  Gap(110.h),
                  AppButton.withWidget(
                    onTap: () {
                      Get.toNamed(AppPath.setProfile);
                    },
                    widget: Row(
                      children: [
                        Gap(24.w),
                        Image.asset(
                          AppIcon.apple.uri,
                          width: 20.r,
                          height: 20.r,
                        ),
                        Gap(13.w),
                        Text(
                          AppMessage.appleLogin.tr,
                          style: AppTextStyle.buttonStyle,
                        ),
                        const Spacer(),
                        Image.asset(
                          AppIcon.next.uri,
                          width: 20.r,
                          height: 20.r,
                        ),
                        Gap(21.w),
                      ],
                    ),
                  ),
                  Gap(32.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppCheckBox(
                        checked: true,
                        onChanged: (_) {},
                      ),
                      Gap(8.w),
                      Expanded(
                        child: Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                  text: AppMessage.loginItemsTip.tr,
                                  style: AppTextStyle.bodySmall,
                                  children: [
                                    const TextSpan(text: '\t'),
                                    TextSpan(
                                      text: AppMessage.userAgreement.tr,
                                      style: AppTextStyle.bodySmall.copyWith(
                                        color: AppColor.pink,
                                      ),
                                    ),
                                    const TextSpan(text: '\t'),
                                    TextSpan(text: AppMessage.and.tr),
                                    const TextSpan(text: '\t'),
                                    TextSpan(
                                      text: AppMessage.privacyAgreement.tr,
                                      style: AppTextStyle.bodySmall.copyWith(
                                        color: AppColor.pink,
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
