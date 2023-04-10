import 'package:alita/http/http.dart';

abstract class DeviceApi {
  static Future saveDeviceInfo() {
    return Http.instance.get(ApiRequest('/api/device/save')).then((value) {});
  }
}
