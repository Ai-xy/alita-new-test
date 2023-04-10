import 'dart:async';
import 'dart:collection';
import 'package:alita/kit/app_nim_kit.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/model/api/user_profile_model.dart';
import 'package:alita/pages/home/country_service.dart';
import 'package:alita/util/log.dart';
import 'package:get/get.dart';

abstract class BaseAppController extends GetxController {
  /// 订阅自销毁池
  final Queue<StreamSubscription> _subscriptions = Queue();

  UserProfileModel? get user => UserProfileModel.fromJson(
      AppLocalStorage.getJson(AppStorageKey.user) ?? {});

  String get yxAccid => '${user?.yxAccid}';

  String get userId => '${user?.userId}';

  String get userAvatar => '${user?.icon}';

  String get userNickname => '${user?.nickname}';

  String getCountryEmojiByName(String name) {
    if (Get.isRegistered<CountryService>()) {
      CountryService service = Get.find<CountryService>();
      return service.getCountryEmojiByName(name);
    }
    return name;
  }

  Future saveUserInfo(UserProfileModel user) {
    return Future.wait([
      AppLocalStorage.setString(AppStorageKey.token, '${user.token}'),
      AppLocalStorage.setJson(AppStorageKey.user, user.toJson()),
      AppLocalStorage.setInt(AppStorageKey.userId, user.userId ?? 0),
      AppLocalStorage.setString(AppStorageKey.yxAccid, '${user.yxAccid}'),
    ]);
  }

  Future clearUserInfo(UserProfileModel user) {
    return Future.wait([
      AppLocalStorage.remove(AppStorageKey.token),
      AppLocalStorage.remove(AppStorageKey.user),
      AppLocalStorage.remove(AppStorageKey.userId),
      AppLocalStorage.remove(AppStorageKey.yxAccid),
    ]);
  }

  Future loginYX() {
    return AppNimKit.instance.login();
  }

  @override
  void onClose() {
    while (_subscriptions.isNotEmpty) {
      var sub = _subscriptions.removeFirst();
      sub.cancel();
    }
    super.onClose();
    Log.i('Subscriptions size:${_subscriptions.length}', tag: 'onClose $this');
  }

  void addSubscription(StreamSubscription sub) {
    _subscriptions.add(sub);
  }
}
