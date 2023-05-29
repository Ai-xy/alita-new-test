import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/kit/app_date_time_kit.dart';
import 'package:alita/model/ui/app_conversation_model.dart';
import 'package:alita/pages/session_list/session_list_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:alita/widgets/app_slide_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nim_core/nim_core.dart';

class SessionCard extends GetView<SessionListController> {
  final AppUserConversationModel conversation;
  const SessionCard({Key? key, required this.conversation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NIMSession session = conversation.session;
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppPath.chat, arguments: conversation)?.then((value) {
          controller.fetchData();
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Slidable(
        endActionPane: const ActionPane(
          extentRatio: 0.2,
          motion: StretchMotion(),
          children: [AppSlideAction(icon: AppIcon.delete)],
        ),
        child: HookBuilder(builder: (context) {
          SlidableController? slidableController = Slidable.of(context);
          ValueNotifier<bool> hasSlided = useState(false);
          useEffect(() {
            void listen() {
              slidableController?.animation.value == 0;
              hasSlided.value = slidableController?.animation.value != 0;
            }

            slidableController?.animation.addListener(listen);
            return () {
              slidableController?.animation.removeListener(listen);
              slidableController?.dispose();
            };
          }, []);

          return AnimatedContainer(
            color: hasSlided.value ? const Color(0xFFF6F1E5) : null,
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            height: 70.h,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Stack(
                  children: [
                    AppImage(
                      '${conversation.nimUser?.avatar}',
                      width: 48.r,
                      height: 48.r,
                      borderRadius: BorderRadius.circular(24.r),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 1.h,
                      right: 0,
                      child: session.unreadCount != 0
                          ? Container(
                              width: 12.r,
                              height: 12.r,
                              decoration: BoxDecoration(
                                color: AppColor.messageBadageColor,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${session.unreadCount}',
                                style: TextStyle(
                                    fontSize: 9.sp, color: AppColor.white),
                              ),
                            )
                          : Container(),
                    )
                  ],
                ),
                Gap(10.w),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width - 32.w - 48.r - 10.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            /// tip类型消息
                            child: Text(
                              session.lastMessageType == NIMMessageType.tip
                                  ? AppMessage.officalNotice.tr
                                  : '${session.senderNickname}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: AppFontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            formatMillseconds(session.lastMessageTime ?? 0),
                            style: TextStyle(fontSize: 12.sp),
                          )
                        ],
                      ),
                    ),
                    Gap(4.h),
                    Text(
                      '${session.lastMessageContent}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColor.black.withOpacity(.5),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
