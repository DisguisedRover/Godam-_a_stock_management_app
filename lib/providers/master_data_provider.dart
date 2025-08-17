import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';

class MasterDataProvider with ChangeNotifier {
  // Base URLs for each endpoint
  static const String _baseUrl = 'https://your-api.com/api';
  final String _baseUnitEndpoint = '/base-units';
  final String _categoryEndpoint = '/categories';
  final String _subCategoryEndpoint = '/sub-categories';
  final String _flavorEndpoint = '/flavors';

  // Data lists
  List<Map<String, dynamic>> _baseUnits = [];
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _subCategories = [];
  List<Map<String, dynamic>> _flavors = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Map<String, dynamic>> get baseUnits => _baseUnits;
  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get subCategories => _subCategories;
  List<Map<String, dynamic>> get flavors => _flavors;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with data fetching
  Future<void> initialize() async {
    // Add mock data for testing
    _addMockData();
    // Simulate a delay for loading
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  // --- MOCK DATA FOR TESTING ---
  void _addMockData() {
    _baseUnits = [
      {
        'id': const Uuid().v4(),
        'unitName': 'PCS',
        'unitValue': 1,
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'unitName': 'KG',
        'unitValue': 1,
        'savedBy': 'admin',
        'savedIn': '2025-05-31 13:21:49',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'unitName': 'LTR',
        'unitValue': 1,
        'savedBy': 'admin',
        'savedIn': '2025-05-31 13:21:41',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'unitName': 'PAU',
        'unitValue': 1,
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'unitName': 'ROLL',
        'unitValue': 1,
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
    ];

    _categories = [
      {
        'id': const Uuid().v4(),
        'categoryName': 'Dairy Products',
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'categoryName': 'Bakery',
        'savedBy': 'admin',
        'savedIn': '2025-05-31 13:21:49',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'categoryName': 'Beverages',
        'savedBy': 'admin',
        'savedIn': '2025-05-31 13:21:41',
        'status': 'Active',
      },
    ];

    _subCategories = [
      {
        'id': const Uuid().v4(),
        'subCategoryName': 'Milk',
        'categoryName': 'Dairy Products',
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'subCategoryName': 'Cheese',
        'categoryName': 'Dairy Products',
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'subCategoryName': 'Bread',
        'categoryName': 'Bakery',
        'savedBy': 'admin',
        'savedIn': '2025-05-31 13:21:49',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'subCategoryName': 'Soda',
        'categoryName': 'Beverages',
        'savedBy': 'admin',
        'savedIn': '2025-05-31 13:21:41',
        'status': 'Active',
      },
    ];

    _flavors = [
      {
        'id': const Uuid().v4(),
        'flavorName': 'Vanilla',
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'flavorName': 'Chocolate',
        'savedBy': 'admin',
        'savedIn': '2025-05-31 13:21:49',
        'status': 'Active',
      },
      {
        'id': const Uuid().v4(),
        'flavorName': 'Strawberry',
        'savedBy': 'admin',
        'savedIn': '2025-05-31 13:21:41',
        'status': 'Active',
      },
    ];
  }

  // --- MODIFIED METHODS FOR MOCKING ---

  // Fetch all base units
  Future<void> fetchBaseUnits() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _baseUnits = _addMockBaseUnits();
    _isLoading = false;
    notifyListeners();
  }

  // Add new base unit
  Future<void> addBaseUnit(Map<String, dynamic> unitData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    unitData['id'] = const Uuid().v4();
    unitData['savedIn'] = DateTime.now().toIso8601String();
    _baseUnits.add(unitData);
    _isLoading = false;
    notifyListeners();
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _categories = _addMockCategories();
    _isLoading = false;
    notifyListeners();
  }

  // Add new category
  Future<void> addCategory(Map<String, dynamic> categoryData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    categoryData['id'] = const Uuid().v4();
    categoryData['savedIn'] = DateTime.now().toIso8601String();
    _categories.add(categoryData);
    _isLoading = false;
    notifyListeners();
  }

  // Fetch all sub-categories
  Future<void> fetchSubCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _subCategories = _addMockSubCategories();
    _isLoading = false;
    notifyListeners();
  }

  // Add new sub-category
  Future<void> addSubCategory(Map<String, dynamic> subCategoryData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    subCategoryData['id'] = const Uuid().v4();
    subCategoryData['savedIn'] = DateTime.now().toIso8601String();
    _subCategories.add(subCategoryData);
    _isLoading = false;
    notifyListeners();
  }

  // Fetch all flavors
  Future<void> fetchFlavors() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _flavors = _addMockFlavors();
    _isLoading = false;
    notifyListeners();
  }

  // Add new flavor
  Future<void> addFlavor(Map<String, dynamic> flavorData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    flavorData['id'] = const Uuid().v4();
    flavorData['savedIn'] = DateTime.now().toIso8601String();
    _flavors.add(flavorData);
    _isLoading = false;
    notifyListeners();
  }

  // Helper method for headers
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your-auth-token',
    };
  }

  // Helper methods to generate fresh mock data
  List<Map<String, dynamic>> _addMockBaseUnits() {
    return [
      {
        'id': const Uuid().v4(),
        'unitName': 'PCS',
        'unitValue': 1,
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      // ... (other base units)
    ];
  }

  List<Map<String, dynamic>> _addMockCategories() {
    return [
      {
        'id': const Uuid().v4(),
        'categoryName': 'Dairy Products',
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      // ... (other categories)
    ];
  }

  List<Map<String, dynamic>> _addMockSubCategories() {
    return [
      {
        'id': const Uuid().v4(),
        'subCategoryName': 'Milk',
        'categoryName': 'Dairy Products',
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      // ... (other sub-categories)
    ];
  }

  List<Map<String, dynamic>> _addMockFlavors() {
    return [
      {
        'id': const Uuid().v4(),
        'flavorName': 'Vanilla',
        'savedBy': 'admin',
        'savedIn': '2025-07-27 12:14:46',
        'status': 'Active',
      },
      // ... (other flavors)
    ];
  }
}
