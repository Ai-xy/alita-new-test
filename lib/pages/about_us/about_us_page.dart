import 'package:alita/R/app_color.dart';
import 'package:alita/R/app_font.dart';
import 'package:alita/R/app_icon.dart';
import 'package:alita/pages/about_us/about_us_controller.dart';
import 'package:alita/pages/about_us/dialog/app_delete_account_dialog.dart';
import 'package:alita/pages/about_us/dialog/app_logout_dialog.dart';
import 'package:alita/model/ui/profile_tile_model.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutUsController>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(AppMessage.aboutUs.tr),
        ),
        backgroundColor: AppColor.white,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                for (ProfileTileModel tile in [
                  ProfileTileModel(
                    label: AppMessage.appPrivacyPolicy.tr,
                    onTap: () {
                      launchUrlString('https://flutter.dev');
                    },
                  ),
                  ProfileTileModel(
                    label: AppMessage.appUserAgreement.tr,
                    onTap: () {
                      launchUrlString('https://flutter.dev');
                    },
                  ),
                  ProfileTileModel(label: AppMessage.appVersion.tr),
                ])
                  GestureDetector(
                    onTap: tile.onTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 50.h,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                              color: AppColor.tileDividerColor, width: 0.8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tile.label,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: AppFontWeight.bold,
                            ),
                          ),
                          tile.label != AppMessage.appVersion.tr
                              ? Image.asset(
                                  AppIcon.tileNext.uri,
                                  width: 20.r,
                                  height: 20.r,
                                  color: AppColor.black,
                                )
                              : Text(
                                  'V1.0.0',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: AppFontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                Gap(60.h),
                AppButton(
                  text: AppMessage.logOut.tr,
                  onTap: () {
                    showAppLogoutDialog(onLogout: _.logOut);
                  },
                ),
                Gap(20.h),
                AppButton(
                  text: AppMessage.deleteAccount.tr,
                  color: AppColor.blackButtonColor,
                  onTap: () {
                    showAppDeleteAccountDialog(
                        onDeleteAccount: _.deleteAccount);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
