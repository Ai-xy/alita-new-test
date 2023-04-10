import 'package:alita/R/app_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppCheckBox extends StatelessWidget {
  final bool checked;
  final ValueChanged<bool> onChanged;
  const AppCheckBox({Key? key, this.checked = false, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (BuildContext context) {
      ValueNotifier<bool> selected = useState(checked);
      useEffect(() {
        void listen() {
          onChanged(selected.value);
        }

        selected.addListener(listen);
        return () {
          selected.removeListener(listen);
        };
      }, []);
      return GestureDetector(
        onTap: () {
          selected.value = !selected.value;
        },
        behavior: HitTestBehavior.opaque,
        child: Image.asset(
          selected.value ? AppIcon.checkedBox.uri : AppIcon.uncheckedBox.uri,
          width: 14.r,
          height: 14.r,
        ),
      );
    });
  }
}
