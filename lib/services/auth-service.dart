import 'package:http/http.dart' as http;

class AuthService {
  static AuthService? _instance;
  bool _isLoggedIn = false;
  String? _accessToken;

  factory AuthService() {
    _instance ??= AuthService._internal();
    return _instance!;
  }

  AuthService._internal();

  bool get isLoggedIn => _isLoggedIn;

  String? get accessToken => _accessToken;

  Future<bool> login(String email, String password) async {
    // Replace this URL with your authentication endpoint
    const url = 'https://backend-etcdp.onespace.et/api/login';

    try {
      // Make a POST request to the authentication endpoint
      final response = await http.post(Uri.parse(url), body: {
        'email': email,
        'password': password,
      });

      // Check if the response was successful
      if (response.statusCode == 200) {
        // Authentication successful
        // You can perform additional operations here, such as saving tokens or user information

        _isLoggedIn = true;
        // _accessToken = response; // Replace with actual access token
        return true;
      } else {
        // Authentication failed
        return false;
      }
    } catch (e) {
      // Error occurred during authentication
      print('Authentication error: $e');
      return false;
    }
  }

  void logout() {
    // Perform logout operations, such as clearing tokens or user information
    _isLoggedIn = false;
    _accessToken = null;
  }
}
