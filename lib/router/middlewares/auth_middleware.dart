import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/mixins/app_auth_binding.dart';
import 'package:alita/router/app_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware with AppAuthBinding {
  @override
  RouteSettings? redirect(String? route) {
    // return const RouteSettings(name: AppPath.login);
    final bool hasLogin =
        AppLocalStorage.getString(AppStorageKey.token)?.isNotEmpty ?? false;
    if (!hasLogin) {
      return const RouteSettings(name: AppPath.login);
    }
    loginYX();
    return null;
  }
}
