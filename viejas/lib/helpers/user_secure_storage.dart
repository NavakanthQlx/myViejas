import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static const _keyUsername = 'username';
  static const _keyPswd = 'password';

  static Future setUsername(String username) async =>
      await _storage.write(key: _keyUsername, value: username);

  static Future<String?> getUsername() async =>
      await _storage.read(key: _keyUsername);

  static Future setPassword(String username) async =>
      await _storage.write(key: _keyPswd, value: username);

  static Future<String?> getPassword() async =>
      await _storage.read(key: _keyPswd);
}
