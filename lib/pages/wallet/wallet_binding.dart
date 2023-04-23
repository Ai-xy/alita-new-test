import 'package:alita/pages/wallet/wallet_controller.dart';
import 'package:get/instance_manager.dart';
// import 'package:get/get.dart';

// import 'wallet_controller.dart';

class WalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WalletController());
  }
}
