import 'package:alita/R/app_icon.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoPlayer extends StatefulWidget {
  final String url;

  const VideoPlayer({super.key, required this.url});

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  final FijkPlayer player = FijkPlayer();

  _VideoPlayerState();

  @override
  void initState() {
    super.initState();
    player.setDataSource(widget.url, autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child: FijkView(
                player: player,
                fit: FijkFit.fill,
              ),
            ),
            Positioned(
                left: 16.w,
                top: 32.w,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    AppIcon.close.uri,
                    width: 24.r,
                    height: 24.r,
                  ),
                ))
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
