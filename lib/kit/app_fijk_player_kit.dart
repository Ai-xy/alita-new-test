import 'package:fijkplayer/fijkplayer.dart';

class FijkPlayerSingleton {
  static FijkPlayerSingleton? _instance;
  FijkPlayer? _fijkPlayer;

  FijkPlayerSingleton._internal() {
    _fijkPlayer = FijkPlayer();
  }

  static FijkPlayerSingleton get instance {
    _instance ??= FijkPlayerSingleton._internal();
    return _instance!;
  }

  FijkPlayer get fijkPlayer => _fijkPlayer!;
}
