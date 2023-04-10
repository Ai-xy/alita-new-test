import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/model/ui/profile_tile_model.dart';
import 'package:alita/pages/edit_profile/dialog/app_rename_dialog.dart';
import 'package:alita/pages/edit_profile/widgets/profile_card.dart';
import 'package:alita/pages/user_profile/user_profile_controller.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class EditProfilePage extends GetView<UserProfileController> {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(builder: (_) {
      final UserProfileModel user = _.user ?? UserProfileModel();
      return Scaffold(
        backgroundColor: AppColor.scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: AppColor.scaffoldBackgroundColor,
          title: Text(AppMessage.editProfile.tr),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          children: [
            ProfileCard(tiles: [
              ProfileTileModel(
                  label: AppMessage.avatar.tr,
                  trailling: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _.updateAvatar,
                    child: AppImage(
                      '${user.icon}',
                      width: 28.r,
                      height: 28.r,
                      fit: BoxFit.fill,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  )),
              ProfileTileModel(
                  label: AppMessage.nickname.tr,
                  trailling: Text('${user.nickname}'),
                  widthDivider: false,
                  onTap: () {
                    showAppRenameDialog(
                      onRename: (String name) {
                        _.updateUserInfo(nickname: name);
                      },
                      initialValue: user.nickname,
                    );
                  }),
            ]),
            Gap(10.h),
            ProfileCard(tiles: [
              ProfileTileModel(
                label: AppMessage.birthday.tr,
                trailling: Text('${user.birthday}'),
                onTap: _.selectBirthday,
              ),
              ProfileTileModel(
                  label: AppMessage.country.tr,
                  trailling:
                      Text(_.getCountryEmojiByName('${_.user?.countryId}')),
                  onTap: _.selectCountry),
              ProfileTileModel(
                  label: AppMessage.personalizedSignature.tr,
                  widthDivider: false,
                  onTap: () {
                    Get.toNamed(AppPath.setMySignature);
                  }),
            ]),
            Gap(10.h),
            Container(
              padding: EdgeInsets.only(
                  left: 15.w, right: 15.w, bottom: 18.h, top: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColor.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppMessage.album.tr,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Gap(14.h),
                  HookBuilder(builder: (context) {
                    final double width =
                        (context.width - 16.w - 12.r * 3) / 3.6;

                    return Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      spacing: 12.w,
                      children: [
                        for (UserMediaModel media in user.pics)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 3.r, top: 3.r),
                                child: AppImage(
                                  '${media.url}',
                                  width: width,
                                  height: width,
                                  fit: BoxFit.fill,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(6.r, -(width + 12.r)),
                                child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () {
                                      _.deleteUserPhoto(media);
                                    },
                                    child: Container(
                                      width: 24.r,
                                      height: 24.r,
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        AppIcon.deletePhoto.uri,
                                        width: 12.r,
                                        height: 12.r,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        GestureDetector(
                          onTap: _.uploadImages,
                          behavior: HitTestBehavior.opaque,
                          child: Image.asset(
                            AppIcon.uploadPhoto.uri,
                            width: width,
                            height: width,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    );
                  })
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
