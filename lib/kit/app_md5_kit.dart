import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:hex/hex.dart';

abstract class AppMd5Kit {
  static String generateMd5(String data) {
    Uint8List content = const Utf8Encoder().convert(data);
    Digest digest = md5.convert(content);
    HexCodec hex = const HexCodec();
    return hex.encode(digest.bytes);
  }
}
