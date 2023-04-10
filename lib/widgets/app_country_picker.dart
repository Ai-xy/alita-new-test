import 'package:alita/model/api/country_model.dart';
import 'package:alita/pages/home/country_service.dart';
import 'package:alita/translation/app_translation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<CountryModel?> showAppCountryPicker({String? countryId}) {
  return Get.bottomSheet(AppCountrySheet(
    initialValue: countryId,
  ));
}

class AppCountrySheet extends StatefulWidget {
  final String? initialValue;

  const AppCountrySheet({Key? key, this.initialValue}) : super(key: key);

  @override
  State<AppCountrySheet> createState() => _AppCountrySheetState();
}

class _AppCountrySheetState extends State<AppCountrySheet> {
  FixedExtentScrollController? scrollController;
  List<CountryModel> options = [];
  int currentIndex = 0;
  @override
  void initState() {
    if (Get.isRegistered<CountryService>()) {
      CountryService service = Get.find<CountryService>();
      options = service.countryList;
    }
    currentIndex = options.indexWhere((e) => e.en == widget.initialValue);
    currentIndex = currentIndex < 0 ? 0 : currentIndex;
    scrollController = FixedExtentScrollController(initialItem: currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
      child: Container(
        height: 268.h,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              height: 44.h,
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: const Color(0xFFFFAA00),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: Get.back, child: Text(AppMessage.cancel.tr)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back(result: options[currentIndex]);
                      },
                      child: Text(AppMessage.done.tr),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                child: CupertinoPicker.builder(
              itemBuilder: (BuildContext context, int index) {
                final CountryModel item = options[index];
                return Center(
                    child: Text(
                  '${item.en}',
                  style: TextStyle(fontSize: 16.sp),
                ));
              },
              scrollController: scrollController,
              childCount: options.length,
              onSelectedItemChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemExtent: 42.h,
            ))
          ],
        ),
      ),
    );
  }
}
