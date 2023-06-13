import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/enum/app_report_type.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportCommonController extends BaseAppController {
  TextEditingController textReportController = TextEditingController();
  AppReportType? appReportType;
  String reportContent = '';
  final int? reportUserId;
  ReportCommonController(this.reportUserId);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    textReportController.dispose();
  }

  void setReportContent(String text) {
    reportContent = text;
    update();
  }

  Future reportSubmit() async {
    if (textReportController.text == '') {
      AppToast.alert(message: 'Please complete the information');
    } else {
      if (reportUserId != null) {
        UserApi.report(
                userId: reportUserId!,
                feedback: textReportController.text,
                feedbackType: 'AD')
            .then((value) {
          textReportController.clear();
          Get.back();
        });
      } else {
        AppToast.alert(message: 'report fail');
      }
    }
  }
}
