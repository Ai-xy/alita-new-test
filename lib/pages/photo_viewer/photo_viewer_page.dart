import 'package:alita/R/app_icon.dart';
import 'package:alita/model/ui/app_gallery_model.dart';
import 'package:alita/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewPage extends StatelessWidget {
  final int initalIndex;
  final List<AppGalleryImageModel> imageList;
  const PhotoViewPage({Key? key, this.initalIndex = 0, required this.imageList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      PageController pageController =
          usePageController(initialPage: initalIndex);
      ValueNotifier<int> currentPage = useState(initalIndex);
      return Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int i) {
              final AppGalleryImageModel item = imageList[i];
              return PhotoViewGalleryPageOptions(
                imageProvider: AppNetworkImage(item.url),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * (0.5 + i / 10),
                maxScale: PhotoViewComputedScale.covered * 4.1,
                heroAttributes: PhotoViewHeroAttributes(tag: item.tag),
              );
            },
            itemCount: imageList.length,
            pageController: pageController,
            onPageChanged: (int index) {
              currentPage.value = index;
            },
            scrollDirection: Axis.horizontal,
          ),
          Positioned(
            top: 92.h,
            right: 16.w,
            child: GestureDetector(
              onTap: Get.back,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 48.r,
                height: 48.r,
                alignment: Alignment.center,
                child: Image.asset(
                  AppIcon.exit.uri,
                  width: 24.r,
                  height: 24.r,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
