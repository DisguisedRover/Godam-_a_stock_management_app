import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';

  static const String _rememberMeKey = 'remember_me';
  static const String _rememberedIdentifierKey = 'remembered_identifier';
  static const String _rememberedPasswordKey = 'remembered_password';


  Future<Map<String, dynamic>?> login(
    String identifier,
    String password,
  ) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: authlogin,
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'identifier': identifier, 'password': password}),
      );

      debugPrint("Login request sent to: $uri");
      debugPrint("Login status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

      debugPrint("Login response data: $data");
        if (data['success'] == true) {
          await _saveAuthData(
            data['token'],
            data['user']['id'].toString(),
            data['user']['username'],
            data['user']['email'],
          );
          return data;
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid credentials');
      }

      return null;
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> signup(
    String userName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: authsignup,
      );

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'username': userName,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
        }),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          await _saveAuthData(
            data['token'],
            data['user']['id'].toString(),
            data['user']['userName'],
            data['user']['email'],
          );
          return data;
        }
      } else if (response.statusCode == 400) {
        throw Exception('User with this email or username already exists');
      }

      return null;
    } catch (e) {
      print('Signup error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> editNameUser(
    String newUserName,
    String password,
  ) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: editUserName,
      );
      final token = await getToken();
      final response = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({'userName': newUserName, 'password': password}),
      );
      debugPrint(json.decode(response.body));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          await _updateUserName(newUserName);
          return data;
        }
      }
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          debugPrint('Username edited Successfully');
          return data;
        }
      } else if (response.statusCode == 400) {
        throw Exception('Username edit failed');
      }

      return null;
    } catch (e) {
      debugPrint('Editing username error: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkUserExists(
    String email,
    String userName,
  ) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: checkExistingUser,
        queryParameters: {'email': email, 'userName': userName},
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to check user existence');
      }
    } catch (e) {
      debugPrint('Check user exists error: $e');
      rethrow;
    }
  }

  Future<void> _saveAuthData(
    String token,
    String userId,
    String userName,
    String email,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userNameKey, userName);
    await prefs.setString(_userEmailKey, email);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<void> _updateUserName(String newUserName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, newUserName);
  }

  Future<void> saveRememberMeCredentials(String identifier, String password) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_rememberMeKey, true);
  await prefs.setString(_rememberedIdentifierKey, identifier);
  await prefs.setString(_rememberedPasswordKey, password);
}

Future<void> clearRememberMeCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_rememberMeKey, false);
  await prefs.remove(_rememberedIdentifierKey);
  await prefs.remove(_rememberedPasswordKey);
}

Future<Map<String, String>?> getRememberedCredentials() async {
  final prefs = await SharedPreferences.getInstance();
  final bool rememberMe = prefs.getBool(_rememberMeKey) ?? false;
  
  if (rememberMe) {
    final String? identifier = prefs.getString(_rememberedIdentifierKey);
    final String? password = prefs.getString(_rememberedPasswordKey);
    
    if (identifier != null && password != null) {
      return {
        'identifier': identifier,
        'password': password,
      };
    }
  }
  return null;
}

Future<bool> isRememberMeEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_rememberMeKey) ?? false;
}
}
