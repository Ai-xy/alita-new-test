import 'package:alita/R/app_color.dart';
import 'package:alita/pages/chat/chat_controller.dart';
import 'package:alita/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatAudioMessageCard extends StatefulWidget {
  final bool isSelf;
  final NIMMessage message;
  final ChatController? controller;
  const ChatAudioMessageCard(
      {Key? key,
      required this.isSelf,
      required this.message,
      required this.controller})
      : super(key: key);

  @override
  State<ChatAudioMessageCard> createState() => _ChatAudioMessageCardState();
}

class _ChatAudioMessageCardState extends State<ChatAudioMessageCard> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await widget.controller?.player.openPlayer();
        setState(() {
          isPlaying = true;
        });
        // 播放音频
        await widget.controller?.player
            .startPlayer(
                fromURI: widget.message.messageAttachment?.toMap()['url'],
                whenFinished: () {
                  setState(() {
                    isPlaying = false;
                  });
                  widget.controller?.update();
                })
            .then((value) {
          widget.controller?.update();
        });
      },
      child: widget.isSelf
          ? Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(249, 249, 249, 1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        15.0, 13.0, 20.0, 13.0),
                    child: Text(
                      '${Duration(milliseconds: widget.message.messageAttachment?.toMap()['dur']).inSeconds}S',
                      style: const TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SizedBox(
                        width: 14,
                        child: Image.asset(!isPlaying
                            ? 'assets/images/icon_voice.png'
                            : 'assets/images/icon_voice_play.png')),
                  )
                ],
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: SizedBox(
                      width: 14,
                      child: Image.asset('assets/images/icon_voice.png')),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      15.0, 13.0, 20.0, 13.0),
                  child: Text(
                    '${Duration(milliseconds: widget.message.messageAttachment?.toMap()['dur']).inSeconds}S',
                    style: const TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1)),
                  ),
                )
              ],
            ),
    );
  }
}
