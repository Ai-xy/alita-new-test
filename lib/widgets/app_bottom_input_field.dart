import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_throttle_it/just_throttle_it.dart';

class AppBottomInputField extends StatelessWidget {
  final Function(String)? onSubmitted;
  const AppBottomInputField({Key? key, this.onSubmitted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
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
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    // color: Color(0xFFF9F9F9),
                    child: TextField(
                      focusNode: focusNode,
                      controller: editingController,
                      onSubmitted: (String s) {
                        if (onSubmitted == null) return;
                        onSubmitted!(s);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        focusColor: AppColor.chatContentInputTextFieldColor,
                        fillColor: AppColor.chatContentInputTextFieldColor,
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
                          onTap: () {
                            if (onSubmitted == null) return;
                            Future save() {
                              return Future(() {
                                return onSubmitted!(editingController.text);
                              }).then((value) {
                                Get.back();
                              });
                            }

                            Throttle.seconds(2, save);
                          },
                        ),
                )
              ],
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: emojiPanelVisible.value ? 240.h : 0,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              child: HookBuilder(builder: (context) {
                return EmojiPicker(
                  textEditingController: editingController,
                  config: const Config(
                    columns: 7,
                    bgColor: AppColor.white,
                    recentsLimit: 0,
                  ),
                );
              }),
            )
          ],
        ),
      );
    });
  }
}
