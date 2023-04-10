import 'package:alita/R/app_icon.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:flutter/material.dart';

enum AppGender {
  female(
    code: 2,
    comment: '女',
    icon: AppIcon.female,
    color: Color(0xFFFF8DA7),
    label: AppMessage.female,
  ),
  male(
    code: 1,
    comment: '男',
    icon: AppIcon.male,
    color: Color(0xFF4D82FF),
    label: AppMessage.male,
  ),
  // other(
  //   code: 3,
  //   comment: '其他',
  //   icon: AppIcon.unknownGender,
  //   color: Color(0xFF87D660),
  //   label: AppMessage.other,
  // ),
  // private(
  //   code: 4,
  //   comment: '保密',
  //   icon: AppIcon.privateGender,
  //   color: Color(0xFFFFAA00),
  //   label: AppMessage.private,
  // ),
  ;

  final int code;
  final String comment;
  final AppIcon icon;
  final Color color;
  final AppMessage label;
  const AppGender({
    required this.code,
    required this.comment,
    required this.icon,
    required this.color,
    required this.label,
  });

  static AppGender? fromCode(int code) {
    for (AppGender item in AppGender.values) {
      if (item.code == code) {
        return item;
      }
    }
    return null;
  }
}
