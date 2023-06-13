import 'package:get/get.dart';

import 'report_common_controller.dart';

class ReportCommonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReportCommonController(Get.arguments));
  }
}
