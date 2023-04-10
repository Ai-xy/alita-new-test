import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:alita/kit/app_oss_kit.dart';

class AppOssInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    return AppOssKit.initialize();
  }
}
