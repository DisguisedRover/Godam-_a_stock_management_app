import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VehicleProvider with ChangeNotifier {
  List<Map<String, dynamic>> _vehicles = [];
  List<Map<String, dynamic>> _filteredVehicles = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalItems = 0;
  String? _statusFilter;

  List<Map<String, dynamic>> get vehicles => _vehicles;
  List<Map<String, dynamic>> get filteredVehicles => _filteredVehicles;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();

  Future<void> fetchVehicles() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('https://your-api-endpoint.com/vehicles'),
        headers: {
          'Authorization': 'Bearer your_token_here',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _vehicles = List<Map<String, dynamic>>.from(data['vehicles']);
        _totalItems = _vehicles.length;
        _filteredVehicles = _vehicles;
      } else {
        throw Exception('Failed to load vehicles');
      }
    } catch (e) {
      // Fallback to mock data if API fails (for demo purposes)
      _vehicles = [
        {
          'vehicleNo': '1',
          'isAvailable': true,
          'vehicleName': 'YODDHA VAN',
          'chassisNo': '2891',
          'engineNo': '1',
          'capacity': '2000',
          'mobileNumber': '98XXXXXXXX',
          'servicingPeriod': '90',
          'servicingPeriodType': 'days',
        },
        {
          'vehicleNo': '2',
          'isAvailable': false,
          'vehicleName': 'TRUCKER 100',
          'chassisNo': '3456',
          'engineNo': '2',
          'capacity': '3000',
          'mobileNumber': '98XXXXXXXX',
          'servicingPeriod': '12',
          'servicingPeriodType': 'months',
        },
        {
          'vehicleNo': '3',
          'isAvailable': true,
          'vehicleName': 'CARGO MAX',
          'chassisNo': '7890',
          'engineNo': '3',
          'capacity': '5000',
          'mobileNumber': '98XXXXXXXX',
          'servicingPeriod': '1',
          'servicingPeriodType': 'years',
        },
      ];
      _totalItems = _vehicles.length;
      _filteredVehicles = _vehicles;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveVehicle(Map<String, dynamic> vehicleData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Replace with your actual API endpoint
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/vehicles'),
        headers: {
          'Authorization': 'Bearer your_token_here',
          'Content-Type': 'application/json',
        },
        body: json.encode(vehicleData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to save vehicle');
      }

      // Refresh the list after saving
      await fetchVehicles();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterVehiclesByStatus(String? status) {
    _statusFilter = status?.toLowerCase();
    if (_statusFilter == null || _statusFilter!.isEmpty) {
      _filteredVehicles = _vehicles;
    } else {
      _filteredVehicles = _vehicles.where((vehicle) {
        return vehicle['status']?.toLowerCase() == _statusFilter;
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
