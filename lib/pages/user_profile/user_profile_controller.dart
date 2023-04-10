import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_future_controller.dart';
import 'package:alita/config/app_config.dart';
import 'package:alita/enum/app_gender.dart';
import 'package:alita/kit/app_media_kit.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/router/app_path.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:alita/widgets/app_country_picker.dart';
import 'package:alita/widgets/app_dete_picker.dart';
import 'package:date_format/date_format.dart';
import 'package:get/get.dart';

class UserProfileController
    extends BaseAppFutureLoadStateController<UserProfileModel> {
  @override
  UserProfileModel? user;
  @override
  Future<UserProfileModel> loadData({Map? params}) {
    return UserApi.getUserInfo().then((value) {
      user = value;
      return value;
    }).catchError((err, s) {
      user = UserProfileModel.fromJson(
          AppLocalStorage.getJson(AppStorageKey.user) ?? {});
    }).whenComplete(update);
  }

  Future logout() {
    return AppLocalStorage.remove(AppStorageKey.token).then((value) {
      Get.offAllNamed(AppPath.login);
    });
  }

  Future<UserProfileModel> updateUserInfo({
    String? birthday,
    String? country,
    AppGender? gender,
    String? avatar,
    String? inviteCode,
    String? nickname,
    String? signature,
    List<String>? pics,
    List<int>? deletedPictureList,
    bool withToast = true,
  }) {
    return UserApi.updateUserInfo(
      birthday: birthday,
      country: country,
      gender: gender,
      avatar: avatar,
      inviteCode: inviteCode,
      signature: signature,
      nickname: nickname,
      pics: pics,
      deletedPictureList: deletedPictureList,
    ).then((value) {
      withToast
          ? AppToast.alert(message: AppMessage.successfullyUpdated.tr)
          : null;
      return loadData();
    });
  }

  Future updateAvatar() {
    return AppMediaKit.uploadImage(serverDir: 'userIcon/').then((value) {
      return updateUserInfo(avatar: value);
    });
  }

  Future selectBirthday() {
    return showAppDatePicker(
            context: Get.context!,
            initialDate: DateTime.tryParse('${user?.birthday}'))
        .then((value) {
      if (value == null) return value;
      return updateUserInfo(
          birthday: formatDate(value, [yyyy, '-', mm, '-', dd]));
    });
  }

  Future selectCountry() {
    return showAppCountryPicker(
      countryId: user?.countryId,
    ).then((value) {
      if (value == null) return value;
      return updateUserInfo(country: value.en);
    });
  }

  Future uploadImages() {
    return AppMediaKit.uploadImages(
      serverDir: 'defaultIcon/${AppConfig.env.appId}/1.png',
      withToast: false,
    ).then((value) {
      if (value == null) return value;
      return updateUserInfo(pics: value);
    });
  }

  Future<UserProfileModel> deleteUserPhoto(UserMediaModel media) {
    return updateUserInfo(deletedPictureList: [media.id ?? -1]);
  }
}
