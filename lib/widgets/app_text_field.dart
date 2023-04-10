import 'dart:async';

import 'package:alita/R/app_text_style.dart';
import 'package:alita/event_bus/event_bus.dart';
import 'package:alita/event_bus/events/app_value_changed_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final Function()? onTap;
  final bool enabled;
  final TextInputType? keyboardType;
  final bool readOnly;
  final String? tag;
  final bool obscureText;
  const AppTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.inputFormatters,
    this.onChanged,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.onTap,
    this.enabled = true,
    this.keyboardType,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.readOnly = false,
    this.tag,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return HookBuilder(builder: (context) {
        TextEditingController editingController =
            controller ?? useTextEditingController();

        FocusNode focusNode = useFocusNode();
        useListenable(editingController);
        useListenable(focusNode);

        useEffect(() {
          if (tag == null) return null;
          void listen(AppValueChangedEvent<String> event) {
            if (tag == event.tag) {
              editingController.text = event.value;
            }
          }

          StreamSubscription streamSubscription =
              eventBus.on<AppValueChangedEvent<String>>().listen(listen);
          return streamSubscription.cancel;
        }, []);
        return ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: IgnorePointer(
            ignoring: !enabled,
            child: GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: TextFormField(
                obscureText: obscureText,
                style: AppTextStyle.inputStyle,
                focusNode: focusNode,
                keyboardType: keyboardType,
                onTap: onTap,
                enabled: enabled,
                onChanged: onChanged,
                selectionControls: MaterialTextSelectionControls(),
                controller: editingController,
                inputFormatters: inputFormatters,
                readOnly: readOnly,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTextStyle.hintStyle,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  filled: true,
                  suffixIcon: suffixIcon == null
                      ? null
                      : Container(
                          margin: EdgeInsets.only(right: 25.w),
                          child: suffixIcon,
                        ),
                  suffixIconConstraints: suffixIcon == null
                      ? null
                      : suffixIconConstraints ??
                          BoxConstraints(
                            maxHeight: 18.r,
                            minHeight: 18.r,
                          ),
                  prefixIcon: prefixIcon == null
                      ? SizedBox(
                          width: 24.r,
                          height: 24.r,
                        )
                      : Container(
                          margin: EdgeInsets.only(left: 14.w, right: 10.w),
                          child: prefixIcon,
                        ),
                  prefixIconConstraints: prefixIcon == null
                      ? BoxConstraints(
                          maxHeight: 24.r,
                          minHeight: 20.r,
                          minWidth: 24.r,
                          maxWidth: 24.r,
                        )
                      : prefixIconConstraints ??
                          BoxConstraints(
                            maxHeight: 20.r,
                            minHeight: 20.r,
                            minWidth: 24.w,
                          ),
                ),
              ),
            ),
          ),
        );
      });
    });
  }
}
