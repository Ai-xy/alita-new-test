import 'dart:io';
import 'package:alita/config/app_config.dart';
import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:alita/util/log.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppDeviceInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    return PackageInfo.fromPlatform().then((value) {
      AppConfig.setAppVersion(value.version);
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        return deviceInfoPlugin.androidInfo.then((value) {
          AppConfig.setDeviceId(value.id);
        });
      }
      return deviceInfoPlugin.iosInfo.then((value) {
        AppConfig.setDeviceId(value.identifierForVendor ?? '');
      });
    }).catchError((err, s) {
      Log.e('AppDeviceInitializer初始化出错',
          stackTrace: s, error: err, tag: 'AppDeviceInitializer');
    });
  }
}
