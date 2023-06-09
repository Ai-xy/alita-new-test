import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/api/live_api.dart';
import 'package:alita/model/api/live_room_model.dart';
import 'package:alita/model/ui/app_live_room_model.dart';
import 'package:alita/pages/about_us/dialog/app_logout_dialog.dart';
import 'package:alita/pages/edit_profile/dialog/app_rename_dialog.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_in_app_pip/flutter_in_app_pip.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

String? password = '';
LiveRoomModel? mLiveRoom;
CancelFunc showLiveRoomPinputDialog() {
  return BotToast.showAnimationWidget(
      backgroundColor: AppColor.barrierBackgroundColor,
      allowClick: false,
      wrapAnimation: (AnimationController controller, CancelFunc cancelFunc,
          Widget widget) {
        return FadeTransition(
          opacity: controller,
          child: widget,
        );
      },
      toastBuilder: (CancelFunc cancelFunc) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: cancelFunc,
                child: Container(
                  height: 56.r,
                  margin: EdgeInsets.only(right: 16.w),
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    AppIcon.close.uri,
                    width: 24.r,
                    height: 24.r,
                    color: AppColor.black.withOpacity(.3),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text(
                  AppMessage.enterLiveRoomPassword.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColor.dialogTextColor,
                  ),
                ),
              ),
              Gap(22.h),
              Pinput(
                length: 4,
                defaultPinTheme: PinTheme(
                  height: 54.r,
                  width: 54.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColor.pinputBackgroundColor,
                    border: Border.all(color: AppColor.pinputBorderColor),
                  ),
                ),
              ),
              Gap(37.h),
            ],
          ),
        );
      },
      animationDuration: const Duration(milliseconds: 275));
}

class LiveRoomCard extends StatelessWidget {
  final LiveRoomModel liveRoom;
  final double? height;
  LiveRoomCard({Key? key, required this.liveRoom, this.height})
      : super(key: key);

  int thr = 10000;

  void joinLiveRoom() {
    // if(liveRoom.liveState==2){
    //   Get.toNamed(AppPath.liveRoom,
    //       preventDuplicates: false, arguments: liveRoom);
    // }else{
    //   Get.toNamed(AppPath.anchorLiveEnd,
    //       preventDuplicates: false, arguments: liveRoom);
    // }

    // Get.toNamed(AppPath.anchorLiveEnd,
    //     preventDuplicates: false, arguments: liveRoom);

    ///
    // if (PictureInPicture.isActive) {
    //   PictureInPicture.stopPiP();
    // }
    // CancelFunc cancelFunc = AppToast.loading();
    // LiveApi.getLiveStream(
    //         id: liveRoom.id ?? 0, password: '${liveRoom.password}')
    //     .then((value) {
    //   print('value值');
    //   print(value);
    //   Get.toNamed(AppPath.liveRoom,
    //       arguments: AppLiveRoomModel(liveRoom: liveRoom, streamUrl: value),
    //       preventDuplicates: false);
    // }).whenComplete(cancelFunc);

    if (PictureInPicture.isActive) {
      PictureInPicture.stopPiP();
    }
    CancelFunc cancelFunc = AppToast.loading();
    LiveApi.getLiveStream(
            id: liveRoom.id ?? 0, password: '${liveRoom.password}')
        .then((value) {
      print('value值');
      print(value);
      mLiveRoom = liveRoom;
      if (liveRoom.lockFlag == "1") {
        password = liveRoom.password;
        Get.dialog(passWordDialog());
      } else {
        if (liveRoom.liveState == 2) {
          Get.toNamed(AppPath.liveRoom,
              arguments: AppLiveRoomModel(liveRoom: liveRoom, streamUrl: value),
              preventDuplicates: false);
        } else {
          Get.toNamed(AppPath.anchorLiveEnd,
              preventDuplicates: false, arguments: liveRoom);
        }
      }
    }).whenComplete(cancelFunc);

    return;
  }

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      return GestureDetector(
        onTap: joinLiveRoom,
        behavior: HitTestBehavior.opaque,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            decoration: BoxDecoration(color: AppColor.white),
            child: Column(
              children: [
                Stack(
                  children: [
                    AppImage(
                      '${liveRoom.coverImg}',
                      height: height,
                      fit: BoxFit.fitWidth,
                      width: double.maxFinite,
                    ),
                    Positioned(
                      top: 7.h,
                      right: 5.w,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.5),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              AppIcon.living.uri,
                              width: 18.r,
                              height: 18.r,
                            ),
                            Gap(4.w),
                            Text(
                              liveRoom.sentiment! >= thr
                                  ? '${(liveRoom.sentiment! / 1000).toStringAsFixed(1).replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "")}k'
                                  : liveRoom.sentiment!.toString(),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColor.white,
                              ),
                            ),
                            Gap(8.w),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: 10.h, bottom: 8.h, left: 12.w, right: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${liveRoom.liveRoomName}',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      const Spacer(),
                      if (liveRoom.isPrivate)
                        Image.asset(
                          AppIcon.privateLiveRoom.uri,
                          width: 24.r,
                          height: 24.r,
                        ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget passWordDialog() {
    return const CustomDialog();
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(),
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Image.asset(
                              'assets/images/close.png',
                              color: const Color.fromRGBO(32, 32, 32, .3),
                              height: 24.w,
                              width: 24.w,
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 22.w),
                      child: Text(
                        'The room has a password set, please enter the password',
                        style: TextStyle(
                            color: const Color.fromRGBO(51, 51, 51, 1),
                            fontSize: 16.sp),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const PasswordInput(),
                    Gap(37.w)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key});

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        4,
        (index) => Container(
          width: 54.w,
          height: 54.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            obscureText: true,
            obscuringCharacter: '\u{25CF}',
            maxLength: 1,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(255, 229, 190, 1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              counterText: '',
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                if (_controllers[0].text.isNotEmpty &&
                    _controllers[1].text.isNotEmpty &&
                    _controllers[2].text.isNotEmpty &&
                    _controllers[3].text.isNotEmpty) {
                  for (var node in _focusNodes) {
                    node.unfocus();
                  }
                  if (password ==
                      '${_controllers[0].text}${_controllers[1].text}${_controllers[2].text}${_controllers[3].text}') {
                    // 进入密码房间
                    Get.back();
                    if (mLiveRoom?.liveState == 2) {
                      Get.toNamed(AppPath.liveRoom,
                          arguments: AppLiveRoomModel(
                              liveRoom: mLiveRoom!, streamUrl: value),
                          preventDuplicates: false);
                    } else {
                      Get.toNamed(AppPath.anchorLiveEnd,
                          preventDuplicates: false, arguments: mLiveRoom);
                    }
                  } else {
                    AppToast.alert(message: 'The password is incorrect');
                  }
                } else {
                  _focusNodes[(index + 1) % 4].requestFocus();
                }
              } else {
                _focusNodes[(index + 3) % 4].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
