import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/pages/anchor_live_end/anchor_live_end_controller.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AnchorLiveEndPage extends GetView<AnchorLiveEndController> {
  const AnchorLiveEndPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: Get.width,
        height: Get.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF5D7), Color(0xFFFFFFFF)],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
                left: 16.w,
                top: kToolbarHeight + 10,
                child: GestureDetector(
                  onTap: Get.back,
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    AppIcon.back.uri,
                    width: 24.r,
                    height: 24.r,
                  ),
                )),
            Positioned(
              top: 172.h,
              child: GetBuilder<AnchorLiveEndController>(builder: (_) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppMessage.liveEnded.tr,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                    Gap(12.h),
                    AppImage(
                      '${_.roomAuthor?.icon}',
                      width: 72.r,
                      height: 72.r,
                      borderRadius: BorderRadius.circular(36.r),
                      fit: BoxFit.fill,
                    ),
                    Gap(9.h),
                    Text(
                      '${_.liveRoom.homeownerNickname}',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    Gap(32.h),
                    _.isFollowed
                        ? AppButton(
                            width: 160.w,
                            text: 'Followed',
                            onTap: () {
                              _.isFollowed ? _.unfollow() : _.follow();
                            },
                            textStyle: const TextStyle(
                              color: Color.fromRGBO(254, 166, 35, 1),
                            ),
                            color: const Color.fromRGBO(254, 166, 35, .39),
                            withIcon: true,
                            icon: Image.asset(
                              AppIcon.anchorFollow.uri,
                              width: 20.r,
                              height: 20.r,
                              color: const Color.fromRGBO(254, 166, 35, 1),
                            ),
                          )
                        : AppButton(
                            width: 160.w,
                            text: AppMessage.follow.tr,
                            onTap: () {
                              _.isFollowed ? _.unfollow() : _.follow();
                            },
                            withIcon: true,
                            icon: Image.asset(
                              AppIcon.anchorFollow.uri,
                              width: 20.r,
                              height: 20.r,
                              color: Colors.white,
                            ),
                          ),
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
