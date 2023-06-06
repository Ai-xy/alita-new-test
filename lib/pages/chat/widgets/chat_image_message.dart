import 'dart:io';
import 'package:alita/model/ui/app_gallery_model.dart';
import 'package:alita/pages/photo_viewer/photo_viewer_page.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:alita/widgets/app_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nim_core/nim_core.dart';
import 'package:progressive_image/progressive_image.dart';

class ChatImageMessageCard extends StatelessWidget {
  final NIMMessage message;

  const ChatImageMessageCard({Key? key, required this.message})
      : super(key: key);
  NIMImageAttachment get image =>
      message.messageAttachment as NIMImageAttachment;
  double get ratio {
    if (image.width != null &&
        image.width != 0 &&
        image.height != null &&
        image.height != 0) {
      return image.width! / image.height!;
    }
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (BuildContext context) {
      return StreamBuilder<NIMMessage>(
          stream: NimCore.instance.messageService.onMessageStatus
              .where((event) => event.uuid == message.uuid),
          builder: (context, event) {
            return StreamBuilder<NIMAttachmentProgress>(
              stream: NimCore.instance.messageService.onAttachmentProgress
                  .where((event) => event.id == message.uuid),
              builder: (context, snapshot) {
                return Container(
                  constraints: BoxConstraints(maxWidth: 110.w),
                  child: AspectRatio(
                    aspectRatio: ratio,
                    child: ClipRRect(
                      key: ValueKey('${message.uuid}'),
                      borderRadius: BorderRadius.circular(8.r),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          message.messageDirection ==
                                  NIMMessageDirection.outgoing
                              ? GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => PhotoViewPage(
                                        imageList: ([image.url])
                                            .map((e) => AppGalleryImageModel(
                                                tag: '${image.url}',
                                                url: '${image.url}'))
                                            .toList(),
                                      ),
                                    ));
                                  },
                                  child: Hero(
                                      tag: '${image.url}',
                                      child: AppImage(
                                        '${image.url}',
                                        fit: BoxFit.fill,
                                      )
                                      //   Image.file(
                                      //   File('${image.path}'),
                                      //   fit: BoxFit.fill,
                                      // ),
                                      ),
                                )
                              // Image.file(
                              //           File('${image.path}'),
                              //           fit: BoxFit.fill,
                              //         )
                              : ProgressiveImage(
                                  // size: 1.87KB
                                  thumbnail: NetworkImage('${image.thumbUrl}'),
                                  // size: 1.29MB
                                  image: NetworkImage('${image.url}'),
                                  height: 110.w * ratio,
                                  width: 110.w,
                                  fit: BoxFit.contain, placeholder: null,
                                ),
                          if (snapshot.data?.progress != 1 &&
                              message.messageDirection ==
                                  NIMMessageDirection.outgoing &&
                              [NIMMessageStatus.sending]
                                  .contains(event.data?.status))
                            AppPercentIndicator(
                              width: 110.w,
                              height: 110.w * ratio,
                              progress: snapshot.data?.progress ?? 0,
                            )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          });
    });
  }
}
