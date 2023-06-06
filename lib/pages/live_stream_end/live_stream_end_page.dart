import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/pages/live_stream_end/live_stream_end_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LiveStreamEndPage extends StatelessWidget {
  const LiveStreamEndPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: Get.width,
        height: Get.height,
        color: const Color(0xFFF6F1E5),
        child: Column(
          children: [
            Gap(kToolbarHeight + 10.h),
            Container(
              margin: EdgeInsets.only(right: 30.w),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  AppIcon.exit.uri,
                  width: 18.r,
                  height: 18.r,
                  color: const Color(0xFF646363),
                ),
              ),
            ),
            Gap(42.h),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppIcon.liveStreamEnd.uri,
                  width: 116.r,
                  height: 116.r,
                ),
                Text(
                  AppMessage.liveStreamHasEnded.tr,
                  style: TextStyle(fontSize: 16.sp),
                ),
                Gap(35.h),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 30.h, horizontal: 40.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: GetBuilder<LiveStreamEndController>(builder: (_) {
                    final TextStyle valueStyle = TextStyle(
                      fontSize: 18.sp,
                      color: AppColor.bodyText2Color,
                      fontWeight: AppFontWeight.bold,
                    );
                    final TextStyle keyStyle = TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.bodyText2Color.withOpacity(.5),
                    );
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Text(
                              '421',
                              style: valueStyle,
                            ),
                            Gap(2.h),
                            Text(
                              AppMessage.watchNumber.tr,
                              style: keyStyle,
                            ),
                            Gap(30.h),
                            Text(
                              '1000',
                              style: valueStyle,
                            ),
                            Gap(2.h),
                            Text(
                              AppMessage.getDiamonds.tr,
                              style: keyStyle,
                            ),
                            Gap(30.h),
                            Text(
                              '90',
                              style: valueStyle,
                            ),
                            Gap(2.h),
                            Text(
                              AppMessage.newFollowers.tr,
                              style: keyStyle,
                            ),
                          ],
                        )),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '12: 01: 23',
                              style: valueStyle,
                            ),
                            Gap(2.h),
                            Text(
                              AppMessage.liveDuration.tr,
                              style: keyStyle,
                            ),
                            Gap(30.h),
                            Text(
                              '10',
                              style: valueStyle,
                            ),
                            Gap(2.h),
                            Text(
                              AppMessage.gifitingUsers.tr,
                              style: keyStyle,
                            ),
                          ],
                        )),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
