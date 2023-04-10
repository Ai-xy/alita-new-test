import 'package:alita/util/log.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionKit {
  static Future<bool> checkPermission(Permission permission) {
    return permission.isGranted.then((value) {
      Log.i('检查$permission权限是否开启$value', tag: '权限');
      if (value == true) {
        return true;
      }
      Log.i('正在申请$permission权限', tag: '权限');
      return permission.request().then((value) {
        Log.i('申请$permission权限结果$value 是否开启${value.isGranted}', tag: '权限');
        return value.isGranted;
      });
    });
  }

  static Future<bool> checkRtcPermission() {
    return checkPermission(Permission.camera).then((value) {
      return checkPermission(Permission.microphone);
    });
  }

  static Future<Map<Permission, PermissionStatus>> checkLivePermission() {
    return [
      Permission.camera,
      Permission.audio,
    ].request();
  }
}

extension $PermissionLabel on Permission {
  String get description =>
      {
        Permission.camera: 'Camera',
        Permission.audio: 'Audio',
      }[this] ??
      '';
}
