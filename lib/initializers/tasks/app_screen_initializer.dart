import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppScreenInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)
        .then((value) {
      SystemChrome.setPreferredOrientations([
        // 强制竖屏
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ]);
    });
  }
}
