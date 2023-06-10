import 'package:fijkplayer/fijkplayer.dart';

class FijkPlayerManager {
  FijkPlayerManager._internal();

  factory FijkPlayerManager() => _instance;

  static final FijkPlayerManager _instance = FijkPlayerManager._internal();

  FijkPlayer _fijkPlayer = FijkPlayer();

  FijkPlayer get fijkPlayer => _fijkPlayer;

  void setFijkPlayer(String url) {
    _fijkPlayer = FijkPlayer();
    _fijkPlayer.setDataSource(url, autoPlay: true, showCover: true);
  }



}
