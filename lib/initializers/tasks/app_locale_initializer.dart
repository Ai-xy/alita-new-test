import 'package:alita/config/app_config.dart';
import 'package:alita/config/app_env.dart';
import 'package:alita/config/app_language.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:get/get.dart';

class AppLocaleInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    AppConfig.setAppLocale(Get.deviceLocale ?? AppLanguage.en.locale);
    return Get.updateLocale(Get.deviceLocale ?? AppLanguage.en.locale);
  }
}
