import 'package:alita/R/app_icon.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/manager/auth_manager.dart';
import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/pages/live_room/live_room_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/widgets/app_chatroom/app_chatroom_controller.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

class AppFloatingPlayer extends StatelessWidget {
  final FijkPlayer fijkPlayer;
  final AppLiveRoomModel live;
  const AppFloatingPlayer(
      {Key? key, required this.fijkPlayer, required this.live})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            PictureInPicture.stopPiP();
            Get.toNamed(AppPath.liveRoom,
                arguments: AppLiveRoomModel(
                    liveRoom: live.liveRoom,
                    streamUrl: live.streamUrl,
                    fijkPlayer: fijkPlayer),
                preventDuplicates: false);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: FijkView(
              fit: FijkFit.cover,
              width: 144.w,
              height: 180.h,
              player: fijkPlayer,
              color: Colors.transparent,
              panelBuilder: (FijkPlayer player, FijkData data,
                  BuildContext context, Size viewSize, Rect texturePos) {
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        Positioned(
            top: 6.h,
            right: 7.w,
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  PictureInPicture.stopPiP();
                  await AppLocalStorage.setBool(AppStorageKey.pip, false);
                  fijkPlayer.pause();
                  fijkPlayer.release();
                  NimCore.instance.chatroomService
                      .exitChatroom('${AuthManager().yxRoomId}');
                },
                child: Image.asset(
                  AppIcon.closeVideo.uri,
                  width: 18.r,
                  height: 18.r,
                ))),
      ],
    );
  }
}
