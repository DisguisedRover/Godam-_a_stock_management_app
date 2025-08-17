import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriverProvider with ChangeNotifier {
  List<Map<String, dynamic>> _drivers = [];
  List<Map<String, dynamic>> _filteredDrivers = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalItems = 0;
  String? _statusFilter;

  List<Map<String, dynamic>> get drivers => _drivers;
  List<Map<String, dynamic>> get filteredDrivers => _filteredDrivers;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();

  Future<void> fetchDrivers() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('https://your-api-endpoint.com/drivers'),
        headers: {
          'Authorization': 'Bearer your_token_here',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _drivers = List<Map<String, dynamic>>.from(data['drivers']);
        _totalItems = _drivers.length;
        _filteredDrivers = _drivers;
      } else {
        throw Exception('Failed to load drivers');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      _drivers = [
        {
          'id': '1',
          'driverName': 'BIPIN POLIDL',
          'contactNumber': '97/9/197013',
          'isAvailable': true,
          'savedBy': 'Super Admin User',
          'savedIn': '2025-07-01T18:12:07.000Z',
          'status': 'Active',
        },
      ];
      _totalItems = _drivers.length;
      _filteredDrivers = _drivers;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveDriver(Map<String, dynamic> driverData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/drivers'),
        headers: {
          'Authorization': 'Bearer your_token_here',
          'Content-Type': 'application/json',
        },
        body: json.encode(driverData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to save driver');
      }

      await fetchDrivers();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterDriversByStatus(String? status) {
    _statusFilter = status?.toLowerCase();
    if (_statusFilter == null || _statusFilter!.isEmpty) {
      _filteredDrivers = _drivers;
    } else {
      _filteredDrivers = _drivers.where((driver) {
        return driver['status']?.toLowerCase() == _statusFilter;
      }).toList();
    }
    notifyListeners();
  }

  void goToFirstPage() {
    _currentPage = 1;
    notifyListeners();
  }

  void goToPreviousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      notifyListeners();
    }
  }

  void goToNextPage() {
    if (_currentPage < totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  void goToLastPage() {
    _currentPage = totalPages;
    notifyListeners();
  }
}
