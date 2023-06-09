class AuthManager {
  AuthManager._internal();

  factory AuthManager() => _instance;

  static final AuthManager _instance = AuthManager._internal();

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  // 记录设置云信登录状态为true
  void login() {
    _isLoggedIn = true;
  }

  void logout() {
    _isLoggedIn = false;
  }
}
