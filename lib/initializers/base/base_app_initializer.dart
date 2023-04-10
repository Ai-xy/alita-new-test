import 'package:alita/config/app_env.dart';

abstract class BaseAppInitializer {
  Future initialize(AppEnv env);
}
