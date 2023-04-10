import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

Future showAppRenameDialog(
    {required Function(String) onRename, String? initialValue}) {
  return Get.dialog(AppRenameDialog(
    onRename: onRename,
    initialValue: initialValue,
  ));
}

class AppRenameDialog extends StatelessWidget {
  final Function(String) onRename;
  final String? initialValue;
  const AppRenameDialog({Key? key, required this.onRename, this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        child: HookBuilder(builder: (context) {
          TextEditingController editingController =
              useTextEditingController(text: initialValue);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(32.h),
              Text(
                AppMessage.setNicknameTitle.tr,
                style:
                    TextStyle(fontSize: 16.sp, fontWeight: AppFontWeight.bold),
              ),
              Gap(20.h),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColor.textFieldBorderColor,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: TextFormField(
                    controller: editingController,
                  ),
                ),
              ),
              Gap(32.h),
              Row(
                children: [
                  Expanded(
                      child: AppButton.gray(
                    height: 40.h,
                    text: AppMessage.cancel.tr,
                    onTap: Get.back,
                  )),
                  Gap(14.w),
                  Expanded(
                    child: AppButton(
                      text: AppMessage.confirm.tr,
                      height: 40.h,
                      onTap: () {
                        Future(() {
                          String name = editingController.text.trim();
                          if (name.isEmpty) {
                            throw AppToast.alert(
                                message: AppMessage.emptyNicknameErrorTip.tr);
                          }
                          return onRename(name);
                        }).then((value) {
                          Get.back();
                        });
                      },
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(44.h),
            ],
          );
        }),
      ),
    );
  }
}
