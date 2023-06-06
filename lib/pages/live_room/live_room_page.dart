import 'package:alita/R/app_icon.dart';
import 'package:alita/model/ui/app_live_action_model.dart';
import 'package:alita/pages/live_room/live_room_controller.dart';
import 'package:alita/util/log.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_action_bar.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_message_box.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_watcher_tile.dart';
import 'package:alita/widgets/app_floating_player.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'sheets/live_action_sheet.dart';

class LiveRoomPage extends GetView<LiveRoomController> {
  const LiveRoomPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Log.i('小窗播放');
        Get.back();
        PictureInPicture.startPiP(
            pipWidget: AppFloatingPlayer(
          fijkPlayer: controller.fijkPlayer,
          live: controller.live,
        ));
        return Future.value(true);
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: SizedBox.shrink(),
        ),
        resizeToAvoidBottomInset: false,
        body: GetBuilder<LiveRoomController>(builder: (_) {
          return Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                IgnorePointer(
                  ignoring: true,
                  child: FijkView(
                    fit: FijkFit.cover,
                    width: double.maxFinite,
                    height: Get.mediaQuery.size.height,
                    player: _.fijkPlayer,
                    color: Colors.transparent,
                    cover: AppNetworkImage('${_.live.liveRoom.coverImg}'),
                    panelBuilder: (FijkPlayer player, FijkData data,
                        BuildContext context, Size viewSize, Rect texturePos) {
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                /// 房主头像，昵称
                Positioned(
                    left: 12.w,
                    top: 44.h,
                    right: 18.w,
                    child:
                        AppChatRoomWatcherTile<LiveRoomController>(onClose: () {
                      Get.back();
                      controller.onClose();
                      // PictureInPicture.startPiP(
                      //     pipWidget: AppFloatingPlayer(
                      //   fijkPlayer: controller.fijkPlayer,
                      //   live: controller.live,
                      // ));
                    })),

                /// 房间内聊天信息
                Positioned(
                  bottom: 118.h,
                  left: 16.w,
                  child: const AppChatRoomMessageBox<LiveRoomController>(),
                ),
                Positioned(
                  bottom: 38.h + Get.mediaQuery.padding.bottom,
                  child: AppChatRoomActionBar<LiveRoomController>(
                    onMenuTap: () {
                      /// 房主
                      Get.bottomSheet(_.isRoomOwner
                          ? LiveActionSheet(
                              actions: [
                                AppLiveActionModel(
                                    icon: AppIcon.anchorFlipCamera.uri,
                                    label: 'Flip',
                                    onTap: () {}),
                                AppLiveActionModel(
                                    icon: AppIcon.recordScreen.uri,
                                    label: 'Record screens'),
                                AppLiveActionModel(
                                    icon: AppIcon.clearScreen.uri,
                                    label: 'Clear the screen'),
                                AppLiveActionModel(
                                    icon: AppIcon.liveRoomMore.uri,
                                    label: 'Screenshots'),
                                AppLiveActionModel(
                                    icon: AppIcon.clearScreen.uri,
                                    label: 'Clear the screen'),
                                AppLiveActionModel(
                                    icon: AppIcon.liveRoomMore.uri,
                                    label: 'Screenshots'),
                              ],
                            )

                          /// 非房主
                          : LiveActionSheet(
                              actions: [
                                AppLiveActionModel(
                                    icon: AppIcon.liveRoomMore.uri,
                                    label: 'Screenshots'),
                                AppLiveActionModel(
                                    icon: AppIcon.recordScreen.uri,
                                    label: 'Record screens'),
                                AppLiveActionModel(
                                    icon: AppIcon.clearScreen.uri,
                                    label: 'Clear the screen'),
                                AppLiveActionModel(
                                    icon: AppIcon.liveRoomMore.uri,
                                    label: 'More'),
                              ],
                            ));
                    },
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
