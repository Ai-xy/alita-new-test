import 'package:alita/R/app_icon.dart';
import 'package:alita/model/ui/app_live_action_model.dart';
import 'package:alita/pages/my_live_room/my_live_room_controller.dart';
import 'package:alita/widgets/app_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LiveActionSheet extends StatelessWidget {
  final List<AppLiveActionModel> actions;
  const LiveActionSheet({Key? key, required this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBottomSheet(
      child: Container(
        margin:
            EdgeInsets.only(top: 56.h, left: 20.w, right: 20.w, bottom: 48.h),
        child: Wrap(
          runSpacing: 20.h,
          children: [
            for (AppLiveActionModel item in [
              AppLiveActionModel(
                  icon: AppIcon.anchorFlipCamera.uri, label: 'Flip'),
              AppLiveActionModel(
                  icon: AppIcon.recordScreen.uri, label: 'Record screens'),
              AppLiveActionModel(
                  icon: AppIcon.clearScreen.uri, label: 'Clear the screen'),
              AppLiveActionModel(
                  icon: AppIcon.liveRoomMore.uri, label: 'Screenshots'),
              AppLiveActionModel(
                  icon: AppIcon.clearScreen.uri, label: 'Clear the screen'),
              AppLiveActionModel(
                  icon: AppIcon.liveRoomMore.uri, label: 'Screenshots'),
            ])
              GestureDetector(
                onTap: () {
                  Get.find<MyLiveRoomController>().flipCamera();
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  width: (Get.width - 20.w * 2) / 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        item.icon,
                        width: 40.r,
                        height: 40.r,
                      ),
                      Gap(13.h),
                      Text(
                        item.label,
                        style: TextStyle(fontSize: 12.sp),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
