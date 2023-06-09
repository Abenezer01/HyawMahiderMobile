import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  StorageService._internal();

  factory StorageService() {
    return _instance;
  }

  Future<void> setToken(String token, key) async {
    await _storage.write(key: key, value: token);
  }

  Future<String?> getToken(key) async {
    return await _storage.read(key: key);
  }

  Future<void> removeToken(key) async {
    await _storage.delete(key: key);
  }
}
