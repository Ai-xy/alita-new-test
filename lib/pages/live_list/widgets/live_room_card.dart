import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/api/live_api.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

CancelFunc showLiveRoomPinputDialog() {
  return BotToast.showAnimationWidget(
      backgroundColor: AppColor.barrierBackgroundColor,
      allowClick: false,
      wrapAnimation: (AnimationController controller, CancelFunc cancelFunc,
          Widget widget) {
        return FadeTransition(
          opacity: controller,
          child: widget,
        );
      },
      toastBuilder: (CancelFunc cancelFunc) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: cancelFunc,
                child: Container(
                  height: 56.r,
                  margin: EdgeInsets.only(right: 16.w),
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    AppIcon.close.uri,
                    width: 24.r,
                    height: 24.r,
                    color: AppColor.black.withOpacity(.3),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text(
                  AppMessage.enterLiveRoomPassword.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColor.dialogTextColor,
                  ),
                ),
              ),
              Gap(22.h),
              Pinput(
                length: 4,
                defaultPinTheme: PinTheme(
                  height: 54.r,
                  width: 54.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColor.pinputBackgroundColor,
                    border: Border.all(color: AppColor.pinputBorderColor),
                  ),
                ),
              ),
              Gap(37.h),
            ],
          ),
        );
      },
      animationDuration: const Duration(milliseconds: 275));
}

class LiveRoomCard extends StatelessWidget {
  final LiveRoomModel liveRoom;
  final double? height;
  const LiveRoomCard({Key? key, required this.liveRoom, this.height})
      : super(key: key);

  void joinLiveRoom() {
    // if(liveRoom.liveState==2){
    //   Get.toNamed(AppPath.liveRoom,
    //       preventDuplicates: false, arguments: liveRoom);
    // }else{
    //   Get.toNamed(AppPath.anchorLiveEnd,
    //       preventDuplicates: false, arguments: liveRoom);
    // }

    // Get.toNamed(AppPath.anchorLiveEnd,
    //     preventDuplicates: false, arguments: liveRoom);

    if (PictureInPicture.isActive) {
      PictureInPicture.stopPiP();
    }
    CancelFunc cancelFunc = AppToast.loading();
    LiveApi.getLiveStream(
            id: liveRoom.id ?? 0, password: '${liveRoom.password}')
        .then((value) {
      print('value值');
      print(value);
      Get.toNamed(AppPath.liveRoom,
          arguments: AppLiveRoomModel(liveRoom: liveRoom, streamUrl: value),
          preventDuplicates: false);
    }).whenComplete(cancelFunc);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      return GestureDetector(
        onTap: joinLiveRoom,
        behavior: HitTestBehavior.opaque,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: BoxDecoration(color: AppColor.white),
            child: Column(
              children: [
                Stack(
                  children: [
                    AppImage(
                      '${liveRoom.coverImg}',
                      height: height,
                      fit: BoxFit.fitWidth,
                      width: double.maxFinite,
                    ),
                    Positioned(
                      top: 7.h,
                      right: 5.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.5),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppIcon.living.uri,
                              width: 18.r,
                              height: 18.r,
                            ),
                            Gap(4.w),
                            Text(
                              '142.7K',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColor.white,
                              ),
                            ),
                            Gap(8.w),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 10.h, bottom: 8.h, left: 12.w, right: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${liveRoom.liveRoomName}',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      const Spacer(),
                      if (liveRoom.isPrivate)
                        Image.asset(
                          AppIcon.privateLiveRoom.uri,
                          width: 24.r,
                          height: 24.r,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
