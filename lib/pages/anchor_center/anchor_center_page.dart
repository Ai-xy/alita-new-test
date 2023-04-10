import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/pages/anchor_center/anchor_center_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AnchorCenterPage extends StatelessWidget {
  const AnchorCenterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Text(AppMessage.anchorCenter.tr),
      ),
      body: GetBuilder<AnchorCenterController>(
        builder: (_) {
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Gap(18.h),
                  Row(
                    children: [
                      AppImage(
                        '${_.user?.icon}',
                        width: 60.r,
                        height: 60.r,
                        borderRadius: BorderRadius.circular(30.r),
                        fit: BoxFit.fill,
                      ),
                      Gap(15.w),
                      Text(
                        '${_.user?.nickname}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: const Color(0xFF343434),
                          fontWeight: AppFontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Gap(20.h),
                  Container(
                    padding: EdgeInsets.only(
                      left: 10.w,
                      right: 5.w,
                      top: 12.h,
                      bottom: 20.h,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFFFF5D7),
                              Colors.white,
                            ])),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppPath.liveData);
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              Text(
                                AppMessage.dataOfThisMonth.tr,
                                style: TextStyle(
                                  color: AppColor.bodyText2Color,
                                  fontSize: 16.sp,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                AppMessage.more.tr,
                                style: TextStyle(
                                  color: AppColor.hintTextColor,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Image.asset(
                                AppIcon.next.uri,
                                width: 24.r,
                                height: 24.r,
                                color: AppColor.hintTextColor,
                              ),
                            ],
                          ),
                        ),
                        Gap(36.h),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    '5650',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: AppFontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    AppMessage.income.tr,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: AppColor.bodyText2Color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text(
                                      '10h21m13s',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: const Color(0xFF333333),
                                        fontWeight: AppFontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      AppMessage.liveBroadcastDuration.tr,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: AppColor.bodyText2Color,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
