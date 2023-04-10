import 'dart:io';

import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:flutter_background/flutter_background.dart';

class AppWebrtcInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    if (Platform.isAndroid) {
      return FlutterBackground.initialize();
    }
    return Future.value();
  }
}
