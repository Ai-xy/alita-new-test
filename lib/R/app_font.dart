import 'dart:io';

import 'package:flutter/material.dart';

class AppFontWeight {
  static const FontWeight w400 = FontWeight.w400;
  static const FontWeight w500 = FontWeight.w500;
  static const FontWeight w600 = FontWeight.w600;
  static FontWeight bold =
      Platform.isAndroid ? FontWeight.w500 : FontWeight.w600;
}
