import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isAuthenticated = false;
  String? _userId;
  String? _userName;
  String? _userEmail;
  bool _isLoading = true;
  String? _error;

  // Getters to access the state
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  bool get isLoading => _isLoading;
  String? get error => _error;

  AuthProvider() {
    _init(); // Call the initialization method in the constructor
  }

  // Initialize auth state
  Future<void> _init() async {
    try {
      _userId = await _authService.getUserId();
      _userName = await _authService.getUserName();
      _userEmail = await _authService.getUserEmail();

      _isAuthenticated = await _authService.isLoggedIn();
    } catch (e) {
      _resetAuthState();
      _error = 'Failed to initialize auth state';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login method - now accepts identifier (email or username)
  Future<bool> login(String identifier, String password) async {
    _clearError();
    _setLoading(true);

    try {
      final response = await _authService.login(identifier, password);

      if (response != null) {
        _updateAuthState(
          response['user']['id'].toString(),
          response['user']['userName'],
          response['user']['email'],
        );
        return true;
      } else {
        _resetAuthState();
        _error = 'Invalid credentials';
        return false;
      }
    } catch (e) {
      _resetAuthState();
      _error = e.toString().replaceAll('Exception: ', '');
      rethrow;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Signup method - updated parameter order
  Future<bool> signup(
    String userName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    _clearError();
    _setLoading(true);

    try {
      final response = await _authService.signup(
        userName,
        email,
        password,
        confirmPassword,
      );

      if (response != null) {
        _updateAuthState(
          response['user']['id'].toString(),
          response['user']['userName'],
          response['user']['email'],
        );
        return true;
      } else {
        _resetAuthState();
        _error = 'Signup failed. Please try again.';
        return false;
      }
    } catch (e) {
      _resetAuthState();
      _error = e.toString().replaceAll('Exception: ', '');

      if (e.toString().contains('email')) {
        _error = 'Email already in use';
      } else if (e.toString().contains('username')) {
        _error = 'Username already taken';
      }

      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // check existing user method
  Future<Map<String, dynamic>?> checkExistingUser(
    String email,
    String userName,
  ) async {
    _clearError();
    _setLoading(true);

    try {
      final response = await _authService.checkUserExists(email, userName);
      return response;
    } catch (e) {
      _error = 'Error checking user: ${e.toString()}';
      return null;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // edit user name method
  Future<bool> editUserName(String newUserName, String password) async {
    _clearError();
    _setLoading(true);

    try {
      final response = await _authService.editNameUser(newUserName, password);

      if (response != null) {
        _userName = newUserName;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _error = 'Username edit failed: ${e.toString()}';
      return false;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Logout method
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authService.logout();
      _resetAuthState();
    } catch (e) {
      _error = 'Logout failed: ${e.toString()}';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _clearError() {
    _error = null;
  }

  void _updateAuthState(String userId, String userName, String email) {
    _userId = userId;
    _userName = userName;
    _userEmail = email;
    _isAuthenticated = true;
  }

  void _resetAuthState() {
    _userId = null;
    _userName = null;
    _userEmail = null;
    _isAuthenticated = false;
  }

  // Method to refresh user data
  Future<void> refreshUserData() async {
    try {
      _userId = await _authService.getUserId();
      _userName = await _authService.getUserName();
      _userEmail = await _authService.getUserEmail();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to refresh user data';
      notifyListeners();
    }
  }

  Future<void> userPhotoUrl() async {}
}
