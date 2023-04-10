// ignore_for_file: deprecated_member_use, unused_element

import 'dart:io';

import 'package:alita/R/app_icon.dart';
import 'package:alita/config/app_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'dart:ui' as ui show instantiateImageCodec, Codec;

class AppImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  const AppImage(
    this.url, {
    Key? key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: OctoImage(
        key: ValueKey(url),
        image: AppNetworkImage(url),
        width: width,
        height: height,
        fit: fit,
        memCacheHeight: (height ?? 0) ~/ 1,
        memCacheWidth: (width ?? 0) ~/ 1,
        placeholderBuilder: (BuildContext context) {
          return Container(
            width: width,
            height: height,
            color: Colors.black,
          );
        },
        errorBuilder: (BuildContext context, Object err, StackTrace? s) {
          return Image.asset(
            AppIcon.defaultAvatar.uri,
            width: width,
            height: height,
            fit: fit,
          );
        },
      ),
    );
  }
}

/// Image.network方法显示HTTPS图片时忽略证书
class AppNetworkImage extends ImageProvider<AppNetworkImage> {
  const AppNetworkImage(this.url, {this.scale = 1.0, this.headers});

  final String url;

  final double scale;

  final Map<String, String>? headers;

  @override
  Future<AppNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<AppNetworkImage>(this);
  }

  @override
  ImageStreamCompleter load(AppNetworkImage key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
        codec: _loadAsync(key), scale: key.scale);
  }

  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback =
        ((X509Certificate cert, String host, int port) => true);

  Future<ui.Codec> _loadAsync(AppNetworkImage key) async {
    assert(key == this);

    final Uri resolved = Uri.base.resolve(
        url.startsWith(RegExp('(http[s]{0,1}):'))
            ? url
            : '${AppConfig.env.imgUrl}$url');
    final HttpClientRequest request = await _httpClient.getUrl(resolved);
    headers?.forEach((String name, String value) {
      request.headers.add(name, value);
    });
    final HttpClientResponse response = await request.close();
    if (response.statusCode != HttpStatus.ok) {
      throw Exception('HTTP请求失败，状态码: ${response.statusCode}, $resolved');
    }

    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    if (bytes.lengthInBytes == 0) {
      throw Exception('NetworkImageSSL是一个空文件: $resolved');
    }

    return await ui.instantiateImageCodec(bytes);
  }

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final AppNetworkImage typedOther = other;
    return url == typedOther.url && scale == typedOther.scale;
  }

  @override
  int get hashCode => hashValues(url, scale);

  @override
  String toString() => '$runtimeType("$url", scale: $scale)';
}
