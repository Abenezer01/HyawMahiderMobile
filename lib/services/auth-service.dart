import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'storage-service.dart';
import 'package:hyaw_mahider/models/User.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final baseUrl = dotenv.env['API_URL'] != null
      ? dotenv.env['API_URL']! + '/login'
      : 'API_URL not found';

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

  Future<bool> login(String email, String password) async {
    try {
      // Make an API request to your server for authentication
      // For example, using the http package

      // Replace the API_URL with your actual login API URL
      final response = await http.post(Uri.parse(baseUrl),
          body: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        // Authentication successful
        // Extract the token from the response
        String token = json.decode(response.body)['token'];
        // Store the token securely
        await setToken(token);
        final jsonData = jsonDecode(response.body);
        final userJson = jsonData['user'];
        final user = UserModel.fromMap(userJson as Map<String, dynamic>);

        final jsonString = jsonEncode(user.toMap());

        _storage.write(key: 'user', value: jsonString);

        return true;
      } else {
        // Authentication failed
        print('Login failed with status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Error occurred during login
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      // Remove the token from secure storage
      await removeToken();
      return true;
    } catch (e) {
      print("Logout error: $e");
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    // Check if a token exists in secure storage
    String? token = await getToken();
    final user = await _storage.read(key: 'user');
    print('user $user');
    return token != null;
  }

// Inside AuthService class
}

class User {
  final String id;
  final String email;
  final String name;
  // Add other user properties as needed

  User({
    required this.id,
    required this.email,
    required this.name,
    // Initialize other user properties here
  });
}
