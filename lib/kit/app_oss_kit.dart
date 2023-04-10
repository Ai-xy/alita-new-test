import 'dart:io';

import 'package:alita/api/app_api.dart';
import 'package:alita/config/app_config.dart';
import 'package:alita/local_storage/app_local_storge.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:alita/util/toast.dart';
import 'package:aliyun_oss_flutter/aliyun_oss_flutter.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

abstract class AppOssKit {
  static Future initialize() {
    return Future(() {
      OSSClient.init(
          endpoint: 'oss-accelerate.aliyuncs.com',
          bucket: 'app-bucket-test',
          credentials: () {
            return AppApi.getOssToken()
                .then((credentials) => Credentials(
                      accessKeyId: '${credentials.accessKeyId}',
                      accessKeySecret: '${credentials.accessKeySecret}',
                      securityToken: '${credentials.securityToken}',
                      expiration:
                          DateTime.tryParse('${credentials.expiration}'),
                    ))
                .catchError((err, s) {
              throw err;
            });
          });
    });
  }

  static Future<String> uploadImage(
      {required File file, required String dir, bool withToast = true}) {
    CancelFunc? cancelFunc = withToast ? AppToast.loading() : null;
    void closeLoading() {
      if (cancelFunc == null) return;
      cancelFunc();
    }

    final String timeStamp =
        formatDate(DateTime.now(), [yyyy, mm, dd, hh, nn, ss]);
    final String suffix = file.path.substring(file.path.lastIndexOf('.'));
    final String imageName =
        file.path.replaceAll(RegExp('${file.path}\$'), '$timeStamp$suffix');
    return _getOssImageKey(filePath: imageName, file: file).then((key) {
      final String uuid = '$dir$key';
      OSSImageObject ossObject =
          OSSImageObject.fromFile(file: file, uuid: uuid);

      return OSSClient()
          .putObject(object: ossObject, path: 'ios/${AppConfig.env.appId}')
          .then((value) {
        closeLoading();
        withToast
            ? AppToast.alert(message: AppMessage.uploadSuccessfully.tr)
            : null;
        return value.url;
      }).catchError((err, s) {
        closeLoading();
        withToast
            ? AppToast.alert(message: AppMessage.failedToUpload.tr)
            : null;
      });
    });
  }

  static Future<String> _getOssImageKey(
      {required String filePath, required File file}) {
    final String timeStamp = formatDate(DateTime.now(), [yy, mm, dd]);
    final int userId = AppLocalStorage.getInt(AppStorageKey.userId);
    final String hashString = filePath.hashCode.abs().toString();
    return decodeImageFromList(file.readAsBytesSync()).then((value) {
      final String size = '${value.width.toInt()}x${value.height.toInt()}';
      return '$timeStamp/u$userId$hashString$size';
    });
  }
}
