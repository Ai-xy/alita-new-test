import 'package:get/get.dart';
import 'live_anchor_sheet_cotroller.dart';

class LiveAnchorSheetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LiveAnchorSheetController());
  }
}
