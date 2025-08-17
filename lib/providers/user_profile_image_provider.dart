import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PhotoProvider with ChangeNotifier {
  static const String _photoUrlKey = 'user_photo_url';
  static const String _apiEndpoint = '/api/user/photo'; // Your API endpoint

  String? _photoUrl;
  bool _isLoading = false;
  String? _error;
  String? _tempLocalPath; // For handling local image before upload

  // Getters
  String? get photoUrl => _photoUrl;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get tempLocalPath => _tempLocalPath;

  PhotoProvider() {
    _loadPhotoUrl();
  }

  Future<void> _loadPhotoUrl() async {
    _setLoading(true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _photoUrl = prefs.getString(_photoUrlKey);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load photo URL');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> uploadPhoto(String imagePath) async {
    _setLoading(true);
    _clearError();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(
        'auth_token',
      ); // Assuming you use same token key

      if (token == null) throw Exception('Not authenticated');

      final uri = Uri(
        scheme: 'https', // or your httpScheme
        host: 'your-api-url.com', // replace with your API_URL
        port: 443, // or your portNo
        path: _apiEndpoint,
      );

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll({
          'Authorization': 'Bearer $token',
          'ngrok-skip-browser-warning': 'true',
        })
        ..files.add(await http.MultipartFile.fromPath('photo', imagePath));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonResponse['success'] == true) {
          final newPhotoUrl = jsonResponse['photoUrl'];
          await prefs.setString(_photoUrlKey, newPhotoUrl);
          _photoUrl = newPhotoUrl;
          _tempLocalPath = null;
          notifyListeners();
          return true;
        }
      }

      _setError(jsonResponse['message'] ?? 'Failed to upload photo');
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deletePhoto() async {
    _setLoading(true);
    _clearError();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Not authenticated');

      final uri = Uri(
        scheme: 'https',
        host: 'your-api-url.com',
        port: 443,
        path: _apiEndpoint,
      );

      final response = await http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove(_photoUrlKey);
        _photoUrl = null;
        notifyListeners();
        return true;
      }

      _setError('Failed to delete photo');
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void setTempImage(String path) {
    _tempLocalPath = path;
    notifyListeners();
  }

  void clearTempImage() {
    _tempLocalPath = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
