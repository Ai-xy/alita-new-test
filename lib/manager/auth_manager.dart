class AuthManager {
  AuthManager._internal();

  factory AuthManager() => _instance;
  String? _yxRoomId;

  static final AuthManager _instance = AuthManager._internal();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  String? get yxRoomId => _yxRoomId;

  // 记录设置云信登录状态为true
  void login() {
    _isLoggedIn = true;
  }

  void logout() {
    _isLoggedIn = false;
  }

  void setRoomId(String yxRoomId) {
    _yxRoomId = yxRoomId;
  }
}
