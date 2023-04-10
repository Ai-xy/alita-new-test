import 'package:alita/R/app_icon.dart';
import 'package:alita/model/ui/app_live_action_model.dart';
import 'package:alita/pages/live_room/sheets/live_action_sheet.dart';
import 'package:alita/pages/my_live_room/my_live_room_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_action_bar.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_message_box.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_watcher_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rtmp_broadcaster/camera.dart';

import 'widgets/count_down_clock.dart';

class MyLiveRoomPage extends StatelessWidget {
  const MyLiveRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<MyLiveRoomController>(builder: (_) {
        return Stack(
          children: [
            Builder(builder: (context) {
              if (_.cameraController?.value.isInitialized != true) {
                return const SizedBox.shrink();
              }
              final CameraController cameraController = _.cameraController!;
              final Size mediaSize = MediaQuery.of(context).size;
              final scale =
                  (cameraController.value.aspectRatio / mediaSize.aspectRatio);
              return Transform.scale(
                scale: scale,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: cameraController.value.aspectRatio,
                    child: CameraPreview(cameraController),
                  ),
                ),
              );
            }),
            const Center(
              child: CountDownClock(),
            ),
            Positioned(
                left: 12.w,
                top: 44.h,
                right: 18.w,
                child:
                    AppChatRoomWatcherTile<MyLiveRoomController>(onClose: () {
                  Get.offAndToNamed(AppPath.liveStreamEnd);
                })),
            Positioned(
              bottom: 118.h,
              left: 16.w,
              child: const AppChatRoomMessageBox<MyLiveRoomController>(),
            ),
            Positioned(
              bottom: 38.h + Get.mediaQuery.padding.bottom,
              child: AppChatRoomActionBar<MyLiveRoomController>(
                onMenuTap: () {
                  Get.bottomSheet(LiveActionSheet(
                    actions: [
                      AppLiveActionModel(
                          icon: AppIcon.anchorFlipCamera.uri,
                          label: AppMessage.flip.tr,
                          onTap: _.flipCamera),
                      AppLiveActionModel(
                          icon: AppIcon.screenshot.uri,
                          label: AppMessage.clearTheScreen.tr),
                      AppLiveActionModel(
                          icon: AppIcon.liveRoomMore.uri, label: 'Screenshots'),
                      AppLiveActionModel(
                          icon: AppIcon.clearScreen.uri,
                          label: AppMessage.screenshots.tr),
                      AppLiveActionModel(
                          icon: AppIcon.liveRoomMore.uri, label: 'Screenshots'),
                      AppLiveActionModel(
                          icon: AppIcon.recordScreen.uri,
                          label: AppMessage.recordScreen.tr),
                    ],
                  ));
                },
              ),
            )
          ],
        );
      }),
    );
  }
}
