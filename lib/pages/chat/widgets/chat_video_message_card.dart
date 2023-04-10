import 'dart:io';

import 'package:alita/kit/app_date_time_kit.dart';
import 'package:alita/util/log.dart';
import 'package:alita/widgets/app_percent_indicator.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nim_core/nim_core.dart';

class ChatVideoMessageCard extends StatelessWidget {
  final NIMMessage message;

  const ChatVideoMessageCard({Key? key, required this.message})
      : super(key: key);
  NIMVideoAttachment get video =>
      message.messageAttachment as NIMVideoAttachment;
  double get ratio {
    if (video.width != null &&
        video.width != 0 &&
        video.height != null &&
        video.height != 0) {
      return video.width! / video.height!;
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (BuildContext context) {
      FijkPlayer fijkPlayer = FijkPlayer();
      double aspectRatio = ratio;

      useEffect(() {
        fijkPlayer.setDataSource('${video.thumbPath}', autoPlay: false);
        return () {
          fijkPlayer.release();
          // fijkPlayer.dispose();
        };
      }, []);

      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 120.w, maxHeight: 240.h),
        child: StreamBuilder<NIMMessage>(
            stream: NimCore.instance.messageService.onMessageStatus,
            builder: (context, event) {
              Log.d('消息状态变化${event.data?.toMap()}');
              return StreamBuilder<NIMAttachmentProgress>(
                stream: NimCore.instance.messageService.onAttachmentProgress
                    .where((e) => e.id == message.uuid),
                builder: (context, snapshot) {
                  return ClipRRect(
                    key: ValueKey('${message.uuid}'),
                    borderRadius: BorderRadius.circular(8.r),
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FijkView(
                            player: fijkPlayer,
                            color: Colors.black,
                            fit: FijkFit.fitHeight,
                            cover: FileImage(File('${video.thumbPath}')),
                          ),
                          if (snapshot.data?.progress != 1 &&
                              message.messageDirection ==
                                  NIMMessageDirection.outgoing &&
                              [NIMMessageStatus.sending]
                                  .contains(event.data?.status))
                            AppPercentIndicator(
                              key: ValueKey(message.uuid),
                              width: 110.w,
                              progress: snapshot.data?.progress ?? 0,
                            ),
                          Positioned(
                            right: 6.w,
                            bottom: 6.h,
                            child: Text(
                              formatTimeMMSS(video.duration ?? 0),
                              style: TextStyle(
                                  fontSize: 10.sp, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
      );
    });
  }
}
