import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/model/ui/chat_action_model.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:nim_core/nim_core.dart';

class ChatBottomInputField extends StatelessWidget {
  final Function(String) onSubmitted;
  final Function()? onImagePicked;
  final Function()? onVideoPicked;
  const ChatBottomInputField(
      {Key? key,
      required this.onSubmitted,
      this.onImagePicked,
      this.onVideoPicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      ValueNotifier<bool> mediaPanelVisible = useState(false);
      ValueNotifier<bool> emojiPanelVisible = useState(false);
      TextEditingController editingController = useTextEditingController();
      FocusNode focusNode = useFocusNode();
      useListenable(editingController);
      useEffect(() {
        void listen() {
          if (emojiPanelVisible.value) {
            focusNode.unfocus();
          }
        }

        emojiPanelVisible.addListener(listen);
        return () {
          emojiPanelVisible.removeListener(listen);
        };
      }, []);

      Future send() {
        return Future(() {
          onSubmitted(editingController.text);
        }).then((value) {
          editingController.clear();
          focusNode.unfocus();
        });
      }

      return Container(
        color: AppColor.white,
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom == 0 ? 34.h : 16.h,
            top: 9.h,
            left: 10.w,
            right: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Image.asset(
                  AppIcon.chatGift.uri,
                  width: 40.r,
                  height: 40.r,
                ),
                Gap(10.w),
                Expanded(
                    child: Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.r),
                          // color: Color(0xFFF9F9F9),
                          child: TextField(
                            focusNode: focusNode,
                            controller: editingController,
                            decoration: InputDecoration(
                              filled: true,
                              focusColor:
                                  AppColor.chatContentInputTextFieldColor,
                              fillColor:
                                  AppColor.chatContentInputTextFieldColor,
                              hintText: AppMessage.enterChatContentHint.tr,
                              suffixIconConstraints: BoxConstraints(
                                maxHeight: 24.r,
                                minHeight: 24.r,
                                maxWidth: 34.r,
                                minWidth: 34.r,
                              ),
                              suffixIcon: Container(
                                  margin: EdgeInsets.only(right: 10.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      emojiPanelVisible.value =
                                          !emojiPanelVisible.value;
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Image.asset(
                                      AppIcon.chatEmoji.uri,
                                      width: 24.r,
                                      height: 24.r,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      margin: EdgeInsets.only(
                          left: editingController.text.isEmpty ? 0 : 10.w),
                      duration: const Duration(milliseconds: 300),
                      child: editingController.text.isEmpty
                          ? const SizedBox.shrink()
                          : AppButton(
                              height: 32.h,
                              width: 64.w,
                              text: AppMessage.send.tr,
                              onTap: send,
                            ),
                    )
                  ],
                )),
                if (editingController.text.isEmpty) ...[
                  Gap(10.w),
                  GestureDetector(
                    onTap: () {
                      mediaPanelVisible.value = !mediaPanelVisible.value;
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Image.asset(
                      AppIcon.chatMedia.uri,
                      width: 24.r,
                      height: 24.r,
                    ),
                  ),
                  Gap(10.w),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onLongPress: () {},
                    onLongPressDown: (LongPressDownDetails details) {
                      NimCore.instance.audioService
                          .startRecord(AudioOutputFormat.AAC, 60);
                    },
                    onLongPressEnd: (LongPressEndDetails details) {
                      NimCore.instance.audioService.stopRecord();
                    },
                    onLongPressCancel: () {
                      NimCore.instance.audioService.cancelRecord();
                    },
                    child: Image.asset(
                      AppIcon.chatVoice.uri,
                      width: 24.r,
                      height: 24.r,
                    ),
                  ),
                ]
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: mediaPanelVisible.value == false
                  ? EdgeInsets.zero
                  : EdgeInsets.symmetric(vertical: 15.h),
              child: mediaPanelVisible.value == false
                  ? const SizedBox.shrink()
                  : Row(
                      children: [
                        for (ChatActionModel item in [
                          ChatActionModel(
                            icon: AppIcon.chatImage.uri,
                            label: AppMessage.pictures.tr,
                            onTap: onImagePicked,
                          ),
                          ChatActionModel(
                            icon: AppIcon.chatVideo.uri,
                            label: AppMessage.video.tr,
                            onTap: onVideoPicked,
                          ),
                        ])
                          Container(
                            margin: EdgeInsets.only(right: 36.w),
                            child: GestureDetector(
                              onTap: () {
                                mediaPanelVisible.value = false;
                                if (item.onTap == null) return;
                                item.onTap!();
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    item.icon,
                                    width: 32.r,
                                    height: 32.r,
                                  ),
                                  Gap(10.h),
                                  Text(
                                    item.label,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF959595),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                      ],
                    ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: emojiPanelVisible.value ? 240.h : 0,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: EmojiPicker(
                textEditingController: editingController,
                config: Config(columns: 7, bgColor: AppColor.white),
              ),
            )
          ],
        ),
      );
    });
  }
}
