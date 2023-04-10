import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/pages/start_live/sheets/live_room_setting_sheet.dart';
import 'package:alita/pages/start_live/start_live_controller.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rtmp_broadcaster/camera.dart';

class StartLivePage extends StatelessWidget {
  const StartLivePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StartLiveController>(builder: (_) {
      return Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Container(),
            if (_.cameraController == null)
              const SizedBox.shrink()
            else
              Builder(
                builder: (context) {
                  CameraController controller = _.cameraController!;
                  final Size mediaSize = MediaQuery.of(context).size;
                  final scale =
                      (controller.value.aspectRatio / mediaSize.aspectRatio);

                  return controller.value.isInitialized == true
                      ? Transform.scale(
                          scale: scale,
                          child: Center(
                            child: AspectRatio(
                                aspectRatio: controller.value.aspectRatio,
                                child: CameraPreview(controller)),
                          ),
                        )
                      : const SizedBox.shrink();
                },
              ),
            ListView(
              padding: EdgeInsets.only(top: 124.h, left: 16.w, right: 16.w),
              children: [
                Gap(32.h),
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.black.withOpacity(.3),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _.uploadCover,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AppImage(
                              '${_.cover}',
                              width: 74.r,
                              height: 74.r,
                              borderRadius: BorderRadius.circular(4.r),
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: Get.width,
                                height: 16.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.5),
                                ),
                                child: Text(
                                  AppMessage.edit.tr,
                                  style: TextStyle(
                                      fontSize: 10.sp, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        margin: EdgeInsets.only(bottom: 14.h),
                        child: Row(
                          children: [
                            Gap(9.w),
                            Image.asset(
                              AppIcon.public.uri,
                              width: 16.r,
                              height: 16.r,
                            ),
                            Gap(9.w),
                            Transform.translate(
                              offset: Offset(0, 1.h),
                              child: Text(
                                AppMessage.public.tr,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColor.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                Gap(14.h),
                Container(
                  padding: EdgeInsets.only(
                    top: 13.h,
                    left: 10.r,
                    right: 10.r,
                    bottom: 25.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.black.withOpacity(.3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppMessage.selectLabel.tr,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: AppFontWeight.bold,
                          color: AppColor.white,
                        ),
                      ),
                      Gap(14.h),
                      Wrap(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              minHeight: 24.h,
                              maxHeight: 24.h,
                              minWidth: 68.w,
                              maxWidth: 68.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14.r),
                              color: Colors.white.withOpacity(.41),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '#\t${AppMessage.hot.tr}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: AppFontWeight.bold,
                                color: AppColor.white,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 92.h,
              right: 16.w,
              child: GestureDetector(
                onTap: Get.back,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 48.r,
                  height: 48.r,
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppIcon.exit.uri,
                    width: 24.r,
                    height: 24.r,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 95.h,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    AppButton(
                      width: Get.mediaQuery.size.width - 30.w * 2,
                      text: AppMessage.startLive.tr,
                      color: AppColor.accentColor,
                      onTap: showLiveRoomSettingSheet,
                    ),
                    Gap(19.h),
                    Text(
                      AppMessage.live.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: AppColor.white,
                      ),
                    ),
                    Gap(13.h),
                    Container(
                      width: 7.r,
                      height: 7.r,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.5.r),
                        color: const Color(0xFFFF325E),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
