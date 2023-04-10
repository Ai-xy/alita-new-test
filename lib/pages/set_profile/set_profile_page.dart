import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/R/app_text_style.dart';
import 'package:alita/enum/app_gender.dart';
import 'package:alita/event_bus/event_bus.dart';
import 'package:alita/event_bus/events/app_value_changed_event.dart';
import 'package:alita/pages/set_profile/set_profile_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:alita/widgets/app_country_picker.dart';
import 'package:alita/widgets/app_dete_picker.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:alita/widgets/app_text_field.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class SetProfilePage extends GetView<SetProfileController> {
  const SetProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(AppIcon.loginBackground.uri),
        Material(
          color: Colors.transparent,
          child: GetBuilder<SetProfileController>(builder: (_) {
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 32.w),
              children: [
                Gap(60.h),
                Transform.translate(
                  offset: Offset(16.w, 0),
                  child: GestureDetector(
                    onTap: () {
                      Get.offAllNamed(AppPath.home);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Text(
                      AppMessage.skip.tr,
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ),
                Gap(48.h),
                Text(
                  AppMessage.welcomeToYonoLive.tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.titleStyle,
                ),
                Gap(6.h),
                Text(
                  AppMessage.setProfileTip.tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.grey,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(24.h),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _.setAvatar,
                    child: Center(
                      child: AppImage(
                        _.userAvatar,
                        width: 70.r,
                        height: 70.r,
                        borderRadius: BorderRadius.circular(35.r),
                        fit: BoxFit.cover,
                      ),
                    )),
                Gap(24.h),
                AppTextField(
                  hintText: AppMessage.bose.tr,
                  onChanged: _.setNickname,
                ),
                Gap(17.h),
                Container(
                  margin: EdgeInsets.only(left: 5.w),
                  child: Text(
                    AppMessage.yourGender.tr,
                    style: AppTextStyle.bodyLarge,
                  ),
                ),
                Gap(12.h),
                Wrap(
                  spacing: 27.w,
                  runSpacing: 16.h,
                  children: [
                    for (AppGender item in AppGender.values)
                      GestureDetector(
                        onTap: () {
                          _.setGender(item);
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 136.w,
                          height: 38.h,
                          decoration: BoxDecoration(
                            color: AppColor.white,
                            borderRadius: BorderRadius.circular(22.r),
                            border: Border.all(
                              color: _.gender == item
                                  ? AppColor.selectedBorderColor
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                item.icon.uri,
                                width: 18.r,
                                height: 18.r,
                              ),
                              Gap(10.w),
                              Text(
                                item.label.tr,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: item.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                Gap(16.h),
                Builder(builder: (context) {
                  const String tag = 'country';
                  return AppTextField(
                    hintText: AppMessage.chooseYourCountry.tr,
                    suffixIcon: Image.asset(AppIcon.dropdown.uri),
                    onTap: () {
                      showAppCountryPicker(countryId: controller.country)
                          .then((value) {
                        if (value == null) return;
                        eventBus.fire(AppValueChangedEvent<String>(
                            value: '${value.en}', tag: tag));
                        _.setCountry('${value.en}');
                      });
                    },
                    tag: tag,
                    readOnly: true,
                  );
                }),
                Gap(16.h),
                Builder(builder: (context) {
                  const String tag = 'birthday';
                  return AppTextField(
                    hintText: AppMessage.chooseYourExactBirthday.tr,
                    suffixIcon: Image.asset(AppIcon.dropdown.uri),
                    tag: tag,
                    onTap: () {
                      showAppDatePicker(context: context).then((value) {
                        if (value == null) return;
                        String date =
                            formatDate(value, [yyyy, '-', mm, '-', dd]);
                        eventBus.fire(AppValueChangedEvent<String>(
                            value: date, tag: tag));
                        _.setBirthday(date);
                      });
                    },
                    readOnly: true,
                  );
                }),
                Gap(69.h),
                AppButton(
                  text: AppMessage.start.tr,
                  color: AppColor.black,
                  onTap: _.save,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
