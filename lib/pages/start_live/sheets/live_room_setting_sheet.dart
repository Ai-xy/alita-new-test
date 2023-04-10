import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/enum/app_live_room_type.dart';
import 'package:alita/pages/start_live/start_live_controller.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_bottom_sheet.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

Future showLiveRoomSettingSheet() {
  return Get.bottomSheet(const LiveRoomSettingSheet(),
      isScrollControlled: true);
}

class LiveRoomSettingSheet extends StatelessWidget {
  const LiveRoomSettingSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StartLiveController>(builder: (_) {
      return AppBottomSheet(
          child: Column(
        children: [
          GestureDetector(
            onTap: Get.back,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 20.h),
              alignment: Alignment.centerRight,
              child: Image.asset(
                AppIcon.exit.uri,
                width: 24.r,
                height: 24.r,
                color: AppColor.black.withOpacity(.5),
              ),
            ),
          ),
          Text(
            AppMessage.whoCanEnterTheRoom.tr,
            style: TextStyle(fontSize: 18.sp, fontWeight: AppFontWeight.bold),
          ),
          Gap(27.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 38.w),
            child: Column(
              children: [
                for (AppLiveRoomType item in AppLiveRoomType.values)
                  GestureDetector(
                    onTap: () {
                      _.setLiveRoomType(item);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.only(left: 12.w),
                      alignment: Alignment.center,
                      height: 56.h,
                      decoration: BoxDecoration(
                          color: _.liveRoomType == item
                              ? const Color(0xFFFEA623).withOpacity(.1)
                              : AppColor.white,
                          border: Border.all(
                              color: _.liveRoomType == item
                                  ? const Color(0xFFFEA623)
                                  : const Color(0xFFECECED)),
                          borderRadius: BorderRadius.circular(8.r)),
                      margin: EdgeInsets.only(bottom: 16.h),
                      child: Row(
                        children: [
                          Image.asset(
                            item.icon.uri,
                            width: 26.r,
                            height: 26.r,
                          ),
                          Gap(7.w),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label.tr,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              Text(
                                item.description.tr,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColor.black.withOpacity(.5),
                                ),
                              )
                            ],
                          ))
                        ],
                      ),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.only(bottom: 32.h),
                  child: TextField(
                    onChanged: _.setRoomPassword,
                    decoration: InputDecoration(
                      hintText: AppMessage.enterRoomPasswordHint.tr,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFECECED),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFECECED),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: const BorderSide(
                          color: Color(0xFFECECED),
                        ),
                      ),
                    ),
                  ),
                ),
                AppButton(
                  text: AppMessage.save.tr,
                  color: AppColor.black,
                  onTap: _.startLive,
                )
              ],
            ),
          )
        ],
      ));
    });
  }
}
