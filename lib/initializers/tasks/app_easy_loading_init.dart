import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EasyLoadingInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    return Future(() => EasyLoading.init());
  }
}
