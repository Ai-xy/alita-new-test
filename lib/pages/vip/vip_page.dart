import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/enum/vip_level.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/percent_indicator.dart';

class VipPage extends StatelessWidget {
  const VipPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: Colors.white,
          ),
          Image.asset(AppIcon.meHeaderBackground.uri),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBar(
                    backgroundColor: Colors.transparent,
                    title: Text(AppMessage.myLevel.tr),
                  ),
                  Gap(16.h),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 3.h),
                            blurRadius: 6.r,
                            spreadRadius: 1.r,
                            color: const Color.fromARGB(
                                0.0784 * 255 ~/ 1, 0, 0, 0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(16.r)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Gap(32.h),
                        Text(
                          '${AppMessage.growthValue.tr} : 499',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF202020),
                          ),
                        ),
                        Gap(4.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Row(
                            children: [
                              Image.asset(
                                AppIcon.level1.uri,
                                width: 20.w,
                                height: 27.h,
                              ),
                              Expanded(
                                  child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 12.w),
                                child: LinearPercentIndicator(
                                  lineHeight: 6.h,
                                  percent: 0.5,
                                  barRadius: Radius.circular(3.r),
                                  backgroundColor: const Color(0xFFF9F9F9),
                                  progressColor:
                                      const Color(0xFF202020).withOpacity(.27),
                                ),
                              )),
                              Image.asset(
                                AppIcon.level8.uri,
                                width: 20.w,
                                height: 27.h,
                              ),
                            ],
                          ),
                        ),
                        Gap(7.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            AppMessage.growthValueDescription.tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              height: 1.35,
                              color: const Color(0xFF202020),
                            ),
                          ),
                        ),
                        Gap(20.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 14.w),
                          child: AppButton(
                            text: AppMessage.levelUpNow.tr,
                            color: AppColor.black,
                          ),
                        ),
                        Gap(24.h),
                      ],
                    ),
                  ),
                  Gap(22.h),
                  Text(
                    AppMessage.levelRule.tr,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                  Gap(6.h),
                  Text(
                    AppMessage.levelRuleDescription.tr,
                    style: TextStyle(
                      fontSize: 14.sp,
                      height: 1.35,
                    ),
                  ),
                  Gap(28.h),
                  Container(
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEA623),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 16.w),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppMessage.level.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppMessage.growthValue.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              AppMessage.level.tr,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppColor.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 48.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.r),
                          bottomRight: Radius.circular(16.r),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 3.r),
                              blurRadius: 5.r,
                              spreadRadius: 1.r,
                              color: const Color.fromARGB(
                                  0.051 * 255 ~/ 1, 0, 0, 0))
                        ]),
                    child: Column(
                      children: [
                        for (VipLevel level in VipLevel.values)
                          SizedBox(
                            height: 48.h,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 20.w),
                                    alignment: Alignment.centerLeft,
                                    child: Image.asset(
                                      level.icon.uri,
                                      width: 18.r,
                                      height: 27.r,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '${level.growthValue}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      level.description.tr,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
