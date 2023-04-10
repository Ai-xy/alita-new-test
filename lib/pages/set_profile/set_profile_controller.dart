import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/enum/app_gender.dart';
import 'package:alita/kit/app_date_time_kit.dart';
import 'package:alita/kit/app_media_kit.dart';
import 'package:alita/kit/app_validate_kit.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_dete_picker.dart';
import 'package:get/get.dart';

class SetProfileController extends BaseAppController {
  String userAvatar = '';
  AppGender? gender;
  String birthday = '1998-01-25';
  String nickname = '';
  String country = 'CA';

  Future setAvatar() {
    return AppMediaKit.uploadImage(serverDir: 'userIcon/', withToast: true)
        .then((avatar) {
      userAvatar = avatar;
    }).whenComplete(update);
  }

  void setNickname(String name) {
    nickname = name;
    update();
  }

  void setGender(AppGender appGender) {
    gender = appGender;
    update();
  }

  void setCountry(String countryId) {
    country = countryId;

    update();
  }

  void setBirthday(String dateTime) {
    birthday = dateTime;
    update();
  }

  Future save() {
    if (isEmpty(nickname)) {
      return Future.error(
          AppToast.alert(message: AppMessage.enterNicknameHint.tr));
    }
    return UserApi.saveUserInfo(
      birthday: birthday,
      avatar: userAvatar,
      nickname: nickname,
      gender: gender,
      country: country,
    ).then((value) {
      Get.offAllNamed(AppPath.home);
      return value;
    });
  }
}
