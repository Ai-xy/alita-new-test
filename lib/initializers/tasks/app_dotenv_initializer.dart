import 'package:alita/config/app_env.dart';
import 'package:alita/initializers/base/base_app_initializer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DotenvInitializer extends BaseAppInitializer {
  @override
  Future initialize(AppEnv env) {
    return dotenv.load(fileName: ".env");
  }
}
