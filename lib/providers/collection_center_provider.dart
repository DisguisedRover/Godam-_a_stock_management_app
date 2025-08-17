import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CollectionCenterProvider with ChangeNotifier {
  List<Map<String, dynamic>> _centers = [];
  List<Map<String, dynamic>> _filteredCenters = [];
  bool _isLoading = false;
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalItems = 0;
  String? _statusFilter;
  String? _branchTypeFilter;

  List<Map<String, dynamic>> get centers => _centers;
  List<Map<String, dynamic>> get filteredCenters => _filteredCenters;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalItems => _totalItems;
  int get totalPages => (_totalItems / _itemsPerPage).ceil();

  Future<void> fetchCollectionCenters() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Replace with your actual API endpoint
      final response = await http.get(
        Uri.parse('https://your-api-endpoint.com/collection-centers'),
        headers: {
          'Authorization': 'Bearer your_token_here',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _centers = List<Map<String, dynamic>>.from(data['centers']);
        _totalItems = _centers.length;
        _filteredCenters = _centers;
      } else {
        throw Exception('Failed to load collection centers');
      }
    } catch (e) {
      // Fallback to mock data if API fails
      _centers = [
        {
          'code': '1',
          'name': '9 CHITWAN MILK LTD',
          'address': 'THIMURA, CHITWAN',
          'contactNo': '0',
          'contactPerson': 'HEM TIWAN',
          'branchType': 'Branch Office',
          'affectsStock': '0',
          'savedBy': 'Super Admin User',
          'savedIn': '2025-07-01T00:00:00.000Z',
          'status': 'Active',
        },
        // Add other mock data entries as shown in your image
      ];
      _totalItems = _centers.length;
      _filteredCenters = _centers;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveCollectionCenter(Map<String, dynamic> centerData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/collection-centers'),
        headers: {
          'Authorization': 'Bearer your_token_here',
          'Content-Type': 'application/json',
        },
        body: json.encode(centerData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to save collection center');
      }

      await fetchCollectionCenters();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterCenters({String? status, String? branchType}) {
    _statusFilter = status?.toLowerCase();
    _branchTypeFilter = branchType?.toLowerCase();

    _filteredCenters = _centers.where((center) {
      final statusMatch =
          _statusFilter == null ||
          center['status']?.toLowerCase() == _statusFilter;
      final typeMatch =
          _branchTypeFilter == null ||
          center['branchType']?.toLowerCase() == _branchTypeFilter;
      return statusMatch && typeMatch;
    }).toList();

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
