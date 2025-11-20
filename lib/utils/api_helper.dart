import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/auth/auth_service.dart';

class ApiHelper {
  static Future<void> handleUnauthorized(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session expired. Please login again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static bool isUnauthorized(http.Response response) {
    return response.statusCode == 401;
  }
}