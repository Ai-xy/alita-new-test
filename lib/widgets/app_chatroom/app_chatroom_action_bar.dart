import 'package:alita/R/app_icon.dart';
import 'package:alita/pages/live_room/sheets/live_gift_sheet.dart';
import 'package:alita/widgets/app_bottom_input_field.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AppChatRoomActionBar<T extends AppChatRoomController>
    extends StatelessWidget {
  final Function()? onMenuTap;
  const AppChatRoomActionBar({Key? key, required this.onMenuTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(builder: (_) {
      return SizedBox(
        width: Get.width,
        child: Row(
          children: [
            Gap(16.w),
            GestureDetector(
              onTap: () {
                Get.bottomSheet(
                  AppBottomInputField(onSubmitted: _.sendMessage),
                  persistent: false,
                  isScrollControlled: true,
                  ignoreSafeArea: true,
                );
              },
              behavior: HitTestBehavior.opaque,
              child: Image.asset(
                AppIcon.liveChat.uri,
                width: 40.r,
                height: 40.r,
              ),
            ),
            Gap(12.w),
            GestureDetector(
              onTap: onMenuTap,
              behavior: HitTestBehavior.opaque,
              child: Image.asset(
                AppIcon.liveMenu.uri,
                width: 40.r,
                height: 40.r,
              ),
            ),
            const Spacer(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Get.bottomSheet(LiveGiftSheet(
                  liveRoom: _.liveRoom,
                ));
              },
              child: Image.asset(
                AppIcon.liveGift.uri,
                width: 40.r,
                height: 40.r,
              ),
            ),
            Gap(20.w),
          ],
        ),
      );
    });
  }
}
