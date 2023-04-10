import 'package:alita/api/app_api.dart';
import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:alita/util/log.dart';

class AppAuthInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    return AppApi.getAbcInfo().catchError((err, s) {
      Log.e('AppAuthInitializer 初始化出错', error: err, stackTrace: s);
    });
  }
}
