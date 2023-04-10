import 'dart:io';

import 'package:alita/api/app_api.dart';
import 'package:alita/kit/app_oss_kit.dart';
import 'package:alita/kit/app_permission_kit.dart';
import 'package:alita/util/log.dart';
import 'package:aliyun_oss_flutter/aliyun_oss_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AppMediaKit {
  static Future init() {
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
              Log.e('初始化OSS失败', tag: 'OSS', error: err, stackTrace: s);
              throw err;
            });
          });
    });
  }

  static Future<XFile?> pickImage({ImageSource source = ImageSource.gallery}) {
    final ImagePicker picker = ImagePicker();
    return AppPermissionKit.checkPermission(Permission.photos).then((value) {
      return picker.pickImage(source: source);
      if (value) {
        return picker.pickImage(source: source);
      }
      throw Future.error('暂无读取相册权限');
    });
  }

  static Future<List<XFile>?> pickMultiImage(
      {ImageSource source = ImageSource.gallery}) {
    final ImagePicker picker = ImagePicker();
    return picker.pickMultiImage();
    return AppPermissionKit.checkPermission(Permission.photos).then((value) {
      // return picker.pickImage(source: source);
      if (value) {
        return picker.pickMultiImage();
      }
      throw Future.error('暂无读取相册权限');
    });
  }

  static Future<XFile?> pickVideo() {
    final ImagePicker picker = ImagePicker();
    return picker.pickVideo(source: ImageSource.gallery);
    // return AppPermissionKit.checkPermission(Permission.photos).then((value) {
    //   // return picker.pickImage(source: source);
    //   if (value) {
    //     return picker.pickMultiImage();
    //   }
    //   throw Future.error('暂无读取相册权限');
    // });
  }

  static Future<String> uploadImage({
    ImageSource source = ImageSource.gallery,
    required String serverDir,
    bool withToast = true,
  }) {
    return pickImage(source: source).then((value) {
      return AppOssKit.uploadImage(
          file: File('${value?.path}'), dir: serverDir, withToast: withToast);
    });
  }

  static Future<List<String>?> uploadImages({
    ImageSource source = ImageSource.gallery,
    required String serverDir,
    bool withToast = true,
    Function()? onUploaded,
  }) {
    return pickMultiImage(source: source).then((value) {
      if (value == null) return Future.value(null);
      return Future.wait(value.map((e) => AppOssKit.uploadImage(
              file: File(e.path), dir: serverDir, withToast: withToast)
          .whenComplete(onUploaded ?? () {})));
    });
  }
}
