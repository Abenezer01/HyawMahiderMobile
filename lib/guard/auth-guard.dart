import 'package:flutter/material.dart';
import 'package:hyaw_mahider/services/auth-service.dart'; // Replace with your own auth service
import 'package:hyaw_mahider/auth/login.dart'; // Replace with your own login screen

class AuthGuard extends StatelessWidget {
  final Widget child;

  AuthGuard({required this.child});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the future is loading, show a loading indicator or splash screen
          return CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data == true) {
          // If the user is authenticated, allow access to the protected route or screen
          return child;
        } else {
          // If the user is not authenticated, redirect to the login screen
          return child; // Replace with your own login screen
        }
      },
    );
  }
}
