import 'package:flutter/material.dart';
import '../services/auth/auth_service.dart';

class AuthGuard {
  static final AuthService _authService = AuthService();

  static Future<bool> checkAuth(BuildContext context) async {
    final isLoggedIn = await _authService.isLoggedIn();
    
    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/');
      return false;
    }
    
    return true;
  }

  static Future<String?> getToken() async {
    return await _authService.getToken();
  }
}