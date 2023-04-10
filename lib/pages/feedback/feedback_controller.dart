import 'package:alita/base/base_app_controller.dart';
import 'package:alita/enum/app_feedback_type.dart';
import 'package:alita/kit/app_media_kit.dart';

class FeedbackController extends BaseAppController {
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
    return AppMediaKit.uploadImages(serverDir: 'feedback/', onUploaded: update)
        .then((value) {
      imageList = value ?? [];
      update();
    });
  }

  Future submit() {
    return Future.value();
  }
}
