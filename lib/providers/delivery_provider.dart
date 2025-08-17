import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class DeliveryProvider with ChangeNotifier {
  List<Map<String, dynamic>> _deliveries = [];
  List<Map<String, dynamic>> _filteredDeliveries = [];
  bool _isLoading = false;

  // Pagination
  int _currentPage = 1;
  static const int _itemsPerPage = 10;

  // Table Filters
  String? _sendFromFilter;
  String? _receivedToFilter;
  String? _shiftFilter;

  // Getters
  List<Map<String, dynamic>> get deliveries => _deliveries;
  List<Map<String, dynamic>> get filteredDeliveries => _filteredDeliveries;
  bool get isLoading => _isLoading;
  int get currentPage => _currentPage;
  int get itemsPerPage => _itemsPerPage;
  int get totalPages => (_filteredDeliveries.length / _itemsPerPage).ceil();

  Future<void> fetchDeliveries({
    String? sendFrom,
    String? receivedTo,
    String? shift,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In a real application, you would make an API call here.
      // For this example, we'll use mock data.
      // The API call would look something like this:
      /*
      final queryParams = {
        'sendFrom': sendFrom,
        'receivedTo': receivedTo,
        'shift': shift,
        'page': _currentPage.toString(),
        'limit': _itemsPerPage.toString(),
      };
      final uri = Uri.https('your-api-endpoint.com', '/deliveries', queryParams);
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer your_token_here',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        _deliveries = List<Map<String, dynamic>>.from(
          json.decode(response.body)['deliveries'],
        );
      } else {
        throw Exception('Failed to load deliveries');
      }
      */

      // Fallback to mock data with a slight delay to simulate network latency
      await Future.delayed(const Duration(milliseconds: 500));
      _deliveries = _generateMockDeliveries();

      // Apply initial filters if provided
      filterDeliveries(
        sendFrom: sendFrom,
        receivedTo: receivedTo,
        shift: shift,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching deliveries: $e');
      }
      _deliveries = [];
      _filteredDeliveries = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void filterDeliveries({String? sendFrom, String? receivedTo, String? shift}) {
    _sendFromFilter = sendFrom;
    _receivedToFilter = receivedTo;
    _shiftFilter = shift;

    _filteredDeliveries = _deliveries.where((delivery) {
      final matchesSendFrom =
          _sendFromFilter == null ||
          delivery['sendFrom']?.toLowerCase() == _sendFromFilter!.toLowerCase();
      final matchesReceivedTo =
          _receivedToFilter == null ||
          delivery['receivedTo']?.toLowerCase() ==
              _receivedToFilter!.toLowerCase();
      final matchesShift =
          _shiftFilter == null ||
          delivery['shift']?.toLowerCase() == _shiftFilter!.toLowerCase();

      return matchesSendFrom && matchesReceivedTo && matchesShift;
    }).toList();

    // Reset page to 1 after filtering
    _currentPage = 1;
    notifyListeners();
  }

  Future<void> saveDelivery(Map<String, dynamic> deliveryData) async {
    _isLoading = true;
    notifyListeners();

    try {
      // In a real app, you would make an API call here.
      /*
      final response = await http.post(
        Uri.parse('https://your-api-endpoint.com/deliveries'),
        headers: {
          'Authorization': 'Bearer your_token_here',
          'Content-Type': 'application/json',
        },
        body: json.encode(deliveryData),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to save delivery');
      }
      */

      // Simulate API response delay and success
      await Future.delayed(const Duration(milliseconds: 500));

      // After saving, re-fetch the data to update the table
      await fetchDeliveries();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pagination methods
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

  List<Map<String, dynamic>> _generateMockDeliveries() {
    final List<Map<String, dynamic>> mockData = [];
    final Random random = Random();

    final sendFroms = ['Collection Center 1', 'Collection Center 2'];
    final receivedTos = ['Plant A', 'Plant B'];
    final shifts = ['morning', 'evening'];
    final vehicleNos = ['BA 1 PA 1234', 'GA 2 YA 5678', 'NA 3 KA 9012'];
    final driverNames = ['John Doe', 'Jane Smith', 'Peter Jones'];
    final status = ['Active', 'Active', 'Active', 'Inactive'];

    for (int i = 0; i < 50; i++) {
      mockData.add({
        'id': (i + 1).toString(),
        'sendFrom': sendFroms[random.nextInt(sendFroms.length)],
        'receivedTo': receivedTos[random.nextInt(receivedTos.length)],
        'shift': shifts[random.nextInt(shifts.length)],
        'dateTime': '2025-08-01 07:00',
        'milkQty': (500 + random.nextInt(500)).toString(),
        'lacto': (random.nextDouble() * 5 + 3.0).toStringAsFixed(1),
        'fat': (random.nextDouble() * 2 + 3.0).toStringAsFixed(1),
        'snf': (random.nextDouble() * 2 + 7.5).toStringAsFixed(1),
        'vehicleNo': vehicleNos[random.nextInt(vehicleNos.length)],
        'driverName': driverNames[random.nextInt(driverNames.length)],
        'status': status[random.nextInt(status.length)],
      });
    }
    return mockData;
  }
}
