import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  AuthService._internal();

  factory AuthService() {
    return _instance;
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> removeToken() async {
    await _storage.delete(key: 'token');
  }
}
