import 'package:get_storage/get_storage.dart';

class SessionService {
  final _storage = GetStorage();

  final _rememberKey = 'remember_me';
  final _emailKey = 'email';
  final _passwordKey = 'password';

  void saveLogin(String email, String password) {
    _storage.write(_rememberKey, true);
    _storage.write(_emailKey, email);
    _storage.write(_passwordKey, password);
  }

  void clearLogin() {
    _storage.remove(_rememberKey);
    _storage.remove(_emailKey);
    _storage.remove(_passwordKey);
  }

  bool isRemembered() {
    return _storage.read(_rememberKey) ?? false;
  }

  Map<String, String> getSavedLogin() {
    return {
      'email': _storage.read(_emailKey) ?? '',
      'password': _storage.read(_passwordKey) ?? '',
    };
  }
}
