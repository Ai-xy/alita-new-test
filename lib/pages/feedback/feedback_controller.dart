import 'package:alita/api/user_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/enum/app_feedback_type.dart';
import 'package:alita/kit/app_media_kit.dart';
import 'package:alita/util/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FeedbackController extends BaseAppController {
  TextEditingController textSuggestionController = TextEditingController();
  TextEditingController textEmailController = TextEditingController();

  AppFeedbackType? appFeedbackType;
  String content = '';
  String email = '';
  List<String> imageList = [];

  void setContent(String text) {
    content = text;
    update();
  }

  void setEmail(String text) {
    email = text;
  }

  Future pickImages() {
    return AppMediaKit.uploadImage(serverDir: 'feedback/').then((value) {
      imageList.add(value);
      update();
    });
  }

  Future submit() async {
    if (textEmailController.text == '' || textSuggestionController.text == '') {
      AppToast.alert(message: 'Please complete the information');
    } else if (validateEmail(textEmailController.text) == false) {
      AppToast.alert(message: 'The mailbox format is incorrect');
    } else {
      UserApi.feedback(
              email: textEmailController.text,
              suggestion: textSuggestionController.text,
              feedbackType: appFeedbackType.toString(),
              imageList: imageList)
          .then((value) {
        textEmailController.clear();
        textSuggestionController.clear();
        Get.back();
      });
    }
  }

  bool validateEmail(String email) {
    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (emailRegExp.hasMatch(email)) {
      return true;
    } else {
      return false;
    }
  }
}
