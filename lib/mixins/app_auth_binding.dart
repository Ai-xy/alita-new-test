import 'package:alita/kit/app_nim_kit.dart';
import 'package:alita/pages/session_list/session_list_controller.dart';
import 'package:get/get.dart';

class AppAuthBinding {

  Future loginYX() {
    return AppNimKit.instance.login();
  }
}
