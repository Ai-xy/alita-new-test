import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/kit/app_fijk_player_kit.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/model/ui/app_live_action_model.dart';
import 'package:alita/pages/live_room/live_room_controller.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_bottom_sheet.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_action_bar.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_message_box.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_watcher_tile.dart';
import 'package:alita/widgets/app_floating_player.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

import 'sheets/live_action_sheet.dart';

class LiveRoomPage extends GetView<LiveRoomController> {
  const LiveRoomPage({Key? key}) : super(key: key);
  //final controller = Get.put(LiveRoomController(live: Get.arguments));
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // final state = LiveRoomController(live: Get.arguments);
        // state.messageList = counter.messageList;
        Log.i('小窗播放');
        // Get.back();
        AppLocalStorage.setBool(AppStorageKey.pip, true);
        PictureInPicture.startPiP(
            pipWidget: AppFloatingPlayer(
          fijkPlayer: FijkPlayerManager().fijkPlayer,
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
          return Screenshot(
            controller: _.screenshotController,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  IgnorePointer(
                    ignoring: true,
                    child: FijkView(
                      fit: FijkFit.cover,
                      width: double.maxFinite,
                      height: Get.mediaQuery.size.height,
                      player: FijkPlayerManager().fijkPlayer,
                      color: Colors.transparent,
                      cover: AppNetworkImage('${_.live.liveRoom.coverImg}'),
                      panelBuilder: (FijkPlayer player,
                          FijkData data,
                          BuildContext context,
                          Size viewSize,
                          Rect texturePos) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),

                  /// 房主头像，昵称
                  Positioned(
                      left: 12.w,
                      top: 44.h,
                      right: 18.w,
                      child: AppChatRoomWatcherTile<LiveRoomController>(
                          onClose: () {
                        AppLocalStorage.setBool(AppStorageKey.pip, false);
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
                        Get.bottomSheet(LiveActionSheet(
                          actions: [
                            AppLiveActionModel(
                                icon: AppIcon.liveRoomMore.uri,
                                label: 'Screenshots',
                                onTap: () {
                                  _.saveScreenshot(context);
                                }),
                            // AppLiveActionModel(
                            //     icon: AppIcon.recordScreen.uri,
                            //     label: 'Record screens'),
                            AppLiveActionModel(
                                icon: AppIcon.clearScreen.uri,
                                label: 'Clear the screen',
                                onTap: () {
                                  _.messageList.clear();
                                }),
                            // AppLiveActionModel(
                            //     icon: AppIcon.liveRoomMore.uri, label: 'More'),
                          ],
                        ));
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
