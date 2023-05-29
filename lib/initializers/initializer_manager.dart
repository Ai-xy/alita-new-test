import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/tasks/app_device_initializer.dart';
import 'package:alita/initializers/tasks/app_net_inspector_initializer.dart';
import 'package:alita/initializers/tasks/app_oss_initializer.dart';
import 'package:alita/initializers/tasks/app_purchase_initializer.dart';
import 'package:flutter/material.dart';
import 'base/base_app_initializer.dart';
import 'tasks/app_easy_loading_init.dart';
import 'tasks/app_locale_initializer.dart';
import 'tasks/app_screen_initializer.dart';
import 'tasks/app_storage_initializer.dart';

abstract class InitializerManager<T extends BaseAppInitializer> {
  static final List<BaseAppInitializer> _initializers = [
    ///SpStorage需要最先初始化
    AppStorageInitializer(),
    AppDeviceInitializer(),
    AppScreenInitializer(),
    AppLocaleInitializer(),
    AppNetInspectorInitializer(),
    // AppAuthInitializer(),
    // AppNIMInitializer(),
    // AppNeRoomInitializer(),
    AppOssInitializer(),
    AppPurchaseInitializer(),

    // AppWebrtcInitializer(),
  ];

  ///进行统一初始化
  static Future initialize(AppEnv env) {
    WidgetsFlutterBinding.ensureInitialized();
    return Future.forEach<BaseAppInitializer>(
        _initializers, (element) => element.initialize(env));
  }
}
