import 'package:alita/R/app_icon.dart';
import 'package:alita/model/ui/app_live_action_model.dart';
import 'package:alita/pages/live_room/sheets/live_action_sheet.dart';
import 'package:alita/pages/my_live_room/my_live_room_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_bottom_sheet.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_action_bar.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_message_box.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_watcher_tile.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:rtmp_broadcaster/camera.dart';
import 'package:screenshot/screenshot.dart';

import 'widgets/count_down_clock.dart';

class MyLiveRoomPage extends StatelessWidget {
  const MyLiveRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<MyLiveRoomController>(builder: (_) {
        return Screenshot(
          controller: _.screenshotController,
          child: Stack(
            children: [
              Builder(builder: (context) {
                if (_.cameraController?.value.isInitialized != true) {
                  return const SizedBox.shrink();
                }
                final CameraController cameraController = _.cameraController!;
                final Size mediaSize = MediaQuery.of(context).size;
                final scale = (cameraController.value.aspectRatio /
                    mediaSize.aspectRatio);
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
                    Get.bottomSheet(confirmSheet(_));
                  })),

              /// im聊天列表
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
                            label: AppMessage.screenshots.tr,
                            onTap: () {
                              _.saveScreenshot(context);
                            }),
                        AppLiveActionModel(
                            icon: AppIcon.anchorRecordScreen.uri,
                            label: AppMessage.recordScreen.tr,
                            onTap: () {
                              AppToast.alert(message: 'start record');
                              _.startRecording();
                            }),
                        AppLiveActionModel(
                            icon: AppIcon.anchorClearScreen.uri,
                            label: AppMessage.clearTheScreen.tr,
                            onTap: () {
                              _.messageList.clear();
                              Get.back();
                            }),
                        AppLiveActionModel(
                            icon: AppIcon.userBlock.uri,
                            label: AppMessage.blockList.tr,
                            onTap: () {
                              Get.toNamed(AppPath.blockList,
                                  arguments: _.liveRoom);
                            }),
                        AppLiveActionModel(
                            icon: AppIcon.liveRoomMore.uri,
                            label: AppMessage.more.tr),
                      ],
                    ));
                  },
                ),
              ),
              _.isRecording
                  ? Positioned(
                      right: 16.w,
                      top: 200.w,
                      child: GestureDetector(
                        onTap: () {
                          _.stopRecording();
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: Container(
                            height: 60.w,
                            width: 60.w,
                            color: Colors.red,
                            child: Center(
                              child: Text(
                                'stop\nrecord',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ))
                  : Container()
            ],
          ),
        );
      }),
    );
  }

  // 确认退出弹框
  Widget confirmSheet(MyLiveRoomController controller) {
    return AppBottomSheet(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Gap(37.w),
            controller.chatroomMemberList.isNotEmpty
                ? Stack(
                    children: [
                      SizedBox(
                        width: 140.w,
                        height: 40.w,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.chatroomMemberList.length <= 3
                              ? controller.chatroomMemberList.length
                              : 3,
                          itemBuilder: (BuildContext context, int index) {
                            return Positioned(
                              right: 10.w,
                              child: Container(
                                height: 40.w,
                                width: 40.w,
                                color: Colors.transparent,
                                child: AppImage(
                                  '${controller.chatroomMemberList[index].avatar}',
                                  height: 40.w,
                                  width: 40.w,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.r),
                          child: Image.asset(
                            'assets/images/icon_more_anthor.png',
                            height: 40.w,
                            width: 40.w,
                          ),
                        ),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: Image.asset(
                      'assets/images/icon_more_anthor.png',
                      height: 40.w,
                      width: 40.w,
                    ),
                  ),
            Gap(16.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: 17.w,
                    width: 17.w,
                    child: Image.asset('assets/images/icon_spectator.png')),
                Gap(5.w),
                Text(
                  'spectator : ${controller.chatroomMemberList.length}',
                  style: TextStyle(
                      color: const Color.fromRGBO(51, 51, 51, 1),
                      fontSize: 14.sp),
                )
              ],
            )
          ],
        ),
        Gap(42.w),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: AppButton(
            onTap: () {
              Get.back();
            },
            text: 'Keep',
            textStyle: TextStyle(color: Colors.white, fontSize: 14.sp),
            color: const Color.fromRGBO(32, 32, 32, 1),
          ),
        ),
        Gap(16.w),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: AppButton(
            text: 'Quit Live',
            textStyle: TextStyle(
                color: const Color.fromRGBO(32, 32, 32, .5), fontSize: 14.sp),
            onTap: () {
              Get.back();
              Get.offAndToNamed(AppPath.liveStreamEnd);
            },
            color: const Color.fromRGBO(249, 249, 249, 1),
          ),
        ),
        Gap(24.w),
      ],
    ));
  }
}
