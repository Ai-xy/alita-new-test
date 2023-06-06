import 'package:alita/api/moment_api.dart';
import 'package:alita/base/base_app_controller.dart';
import 'package:alita/kit/app_media_kit.dart';
import 'package:alita/util/log.dart';
import 'package:alita/util/toast.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateMomentsController extends BaseAppController {
  List<String?>? imgList = [];
  final ImagePicker picker = ImagePicker();
  TextEditingController? textController;
  bool showEmojiPicker = false;
  int textLength = 0;

  @override
  void onInit() {
    super.onInit();
    textController ??= TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    textController?.addListener(_updateTextLength);
  }

  @override
  void onClose() {
    super.onClose();
    textController?.dispose();
  }

  // 上传图像
  Future getImage() async {
    return AppMediaKit.uploadImage(serverDir: 'momentsImages/').then((value) {
      imgList?.add(value);
      update();
    });
  }

  // 统计字数
  void _updateTextLength() {
    textLength = textController!.text.length;
    update();
  }

  // 发布
  void release() {
    if (textController?.text == '') {
      AppToast.alert(message: 'You cant post an empty message');
    } else {
      MomentApi.addMoments(imgList: imgList, txt: textController?.text)
          .then((value) {
        Get.back(result: true);
        update();
      });
    }
  }
}
