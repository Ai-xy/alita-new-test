import 'package:alita/kit/app_permission_kit.dart';
import 'package:alita/util/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rtmp_broadcaster/camera.dart';

class AppLiveBinding {
  Future checkLivePermission() {
    return AppPermissionKit.checkPermission(Permission.camera).then((value) {
      if (!value) {
        return AppPermissionKit.checkPermission(Permission.audio);
      }
    });
  }

  Future<CameraController?> initFrontCameraController({
    bool enableAudio = true,
    bool androidUseOpenGL = true,
  }) {
    return AppPermissionKit.checkLivePermission().then((map) {
      return availableCameras().then((cameras) {
        for (CameraDescription cameraDescription in cameras) {
          if (cameraDescription.lensDirection == CameraLensDirection.front) {
            return CameraController(
              cameraDescription,
              ResolutionPreset.high,
              enableAudio: enableAudio,
              androidUseOpenGL: androidUseOpenGL,
              streamingPreset: ResolutionPreset.high,
            );
          }
        }
        return null;
      });
      Iterable<MapEntry<Permission, PermissionStatus>> entryList =
          map.entries.where((e) => e.value.isGranted != true);
      if (entryList.isEmpty) {
        return availableCameras().then((cameras) {
          for (CameraDescription cameraDescription in cameras) {
            if (cameraDescription.lensDirection == CameraLensDirection.front) {
              return CameraController(
                cameraDescription,
                ResolutionPreset.medium,
                enableAudio: enableAudio,
                androidUseOpenGL: androidUseOpenGL,
              );
            }
          }
          return null;
        });
      }
      throw AppToast.alert(
          message: entryList.map((e) => e.key.description).join(''));
    });
  }
}
