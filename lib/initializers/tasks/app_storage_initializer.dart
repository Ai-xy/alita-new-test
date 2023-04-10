import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:alita/local_storage/app_local_storge.dart';

class AppStorageInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    return AppLocalStorage.init();
  }
}
