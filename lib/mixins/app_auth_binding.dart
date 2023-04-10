import 'package:alita/kit/app_nim_kit.dart';

class AppAuthBinding {
  Future loginYX() {
    return AppNimKit.instance.login();
  }
}
