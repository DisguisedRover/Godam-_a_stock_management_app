import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/warehouses_model.dart';
import '../../utils/api_helper.dart';
import '../auth/auth_service.dart';

class WarehousesService {
  final AuthService _authService = AuthService();

  Future<List<Warehouses>> getWarehousess() async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: getWarehouses,
      );

      final headers = await _authService.getAuthHeaders();
    
      final response = await http.get(uri, headers: headers);

      debugPrint("Get warehousess request sent to: $uri");
      debugPrint("Get warehousess status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint("Get warehousess response: $data");

        if (data is List){
          return data.map((json) => Warehouses.fromJson(json)).toList();
        }else if (data['success'] == true) {
          final List<dynamic> warehousessJson = data['warehousess'];
          return warehousessJson.map((json) => Warehouses.fromJson(json)).toList();
        }else if (data is Map && data.containsKey('warehousess')){
          final List<dynamic> warehousesJson = data['warehousess'];
          return warehousesJson.map((json) => Warehouses.fromJson(json)).toList();
        }
         else {
          throw Exception(data['message'] ?? 'Failed to load warehousess');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Warehousess not found');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else if (response.statusCode == 502) {
        throw Exception('Bad gateway');
      } else if (response.statusCode == 503) {
        throw Exception('Service unavailable');
      } else if (ApiHelper.isUnauthorized(response)) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to load warehousess: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Get warehousess error: $e');
      rethrow;
    }
  }

  Future<Warehouses> getWarehousesById(int warehousesId) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: '$getWarehouseById/$warehousesId', 
      );

      final headers = await _authService.getAuthHeaders();

      final response = await http.get(uri, headers: headers);

      debugPrint("Get warehouses by ID request sent to: $uri");
      debugPrint("Get warehouses status code: ${response.statusCode}");
      debugPrint("Get warehouses by ID response: ${response.body}");

     
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      if (data is Map<String, dynamic> && data.containsKey('warehouses_id')) {
        return Warehouses.fromJson(data);
      } else {
        throw Exception('Invalid warehouses data format');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Warehouses not found');
    } else if (response.statusCode == 400) {
      throw Exception('Bad request');
    } else if (response.statusCode == 403) {
      throw Exception('Access forbidden');
    } else if (response.statusCode == 500) {
      throw Exception('Internal server error');
    } else if (ApiHelper.isUnauthorized(response)) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load warehouses: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Get warehouses by ID error: $e');
    rethrow;
  }
  }

  Future<Warehouses> createWarehouses(Warehouses warehouses) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: saveWarehouse,
      );

      final headers = await _authService.getAuthHeaders();

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(warehouses.toJson()),
      );

      debugPrint("Create warehouses request sent to: $uri");
      debugPrint("Create warehouses body: ${warehouses.toJson()}");
      debugPrint("Create warehouses status code: ${response.statusCode}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Create warehouses response: $data");

        if (data['success'] == true) {
          return Warehouses.fromJson(data['warehouses']);
        } else {
          throw Exception(data['message'] ?? 'Failed to create warehouses');
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Validation error');
      } else if (response.statusCode == 409) {
        throw Exception('Warehouses already exists');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else if (ApiHelper.isUnauthorized(response)) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to create warehouses: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Create warehouses error: $e');
      rethrow;
    }
  }

  Future<bool> updateWarehouses(int warehousesId, Warehouses warehouses) async {
  try {
    final uri = Uri(
      scheme: httpScheme,
      host: API_URL,
      port: portNo,
      path: '$editWarehouse/$warehousesId',
    );

    final headers = await _authService.getAuthHeaders();

    final response = await http.put(
      uri,
      headers: headers,
      body: jsonEncode(warehouses.toJson()),
    );

    debugPrint("Update warehouses request sent to: $uri");
    debugPrint("Update warehouses body: ${warehouses.toJson()}");
    debugPrint("Update warehouses status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint("Update warehouses response: $data");

      final message = data['message']?.toString().toLowerCase() ?? '';
      return message.contains('success') || message.contains('updated');
    } else if (response.statusCode == 400) {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? data['message'] ?? 'Validation error');
    } else if (response.statusCode == 404) {
      throw Exception('Warehouses not found');
    } else if (response.statusCode == 403) {
      throw Exception('Access forbidden');
    } else if (response.statusCode == 409) {
      throw Exception('Conflict - warehouses may have been modified');
    } else if (response.statusCode == 500) {
      throw Exception('Internal server error');
    } else if (ApiHelper.isUnauthorized(response)) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to update warehouses: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Update warehouses error: $e');
    rethrow;
  }
}

Future<bool> deleteWarehouses(int warehousesId) async {
  try {
    final uri = Uri(
      scheme: httpScheme,
      host: API_URL,
      port: portNo,
      path: '$deleteWarehouse/$warehousesId',
    );

    final headers = await _authService.getAuthHeaders();

    final response = await http.delete(uri, headers: headers);

    debugPrint("Delete warehouses request sent to: $uri");
    debugPrint("Delete warehouses status code: ${response.statusCode}");

    if (response.statusCode == 200 || response.statusCode == 204) {
      final data = response.body.isNotEmpty 
          ? jsonDecode(response.body) 
          : {'message': 'Warehouses deleted successfully'};
      debugPrint("Delete warehouses response: $data");

      final message = data['message']?.toString().toLowerCase() ?? '';
      if (message.contains('success') || message.contains('deleted')) {
        return true;
      }
      return false;
    } else if (response.statusCode == 404) {
      throw Exception('Warehouses not found');
    } else if (response.statusCode == 403) {
      throw Exception('Access forbidden');
    } else if (response.statusCode == 409) {
      throw Exception('Cannot delete - warehouses is in use');
    } else if (response.statusCode == 500) {
      throw Exception('Internal server error');
    } else if (ApiHelper.isUnauthorized(response)) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to delete warehouses: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Delete warehouses error: $e');
    rethrow;
  }
}


//   Future<List<Warehouses>> searchWarehousess({
//     String? category,
//     String? type,
//     String? status,
//   }) async {
//     try {
//       final queryParams = <String, String>{};
//       if (category != null) queryParams['category'] = category;
//       if (type != null) queryParams['type'] = type;
//       if (status != null) queryParams['status'] = status;

//       final uri = Uri(
//         scheme: httpScheme,
//         host: API_URL,
//         port: portNo,
//         path: '/api/warehousess/search',
//         queryParameters: queryParams.isNotEmpty ? queryParams : null,
//       );

//       final headers = await _authService.getAuthHeaders();

//       final response = await http.get(uri, headers: headers);

//       debugPrint("Search warehousess request sent to: $uri");
//       debugPrint("Search warehousess status code: ${response.statusCode}");

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         debugPrint("Search warehousess response: $data");

//         if (data['success'] == true) {
//           final List<dynamic> warehousessJson = data['warehousess'];
//           return warehousessJson.map((json) => Warehouses.fromJson(json)).toList();
//         } else {
//           throw Exception(data['message'] ?? 'Failed to search warehousess');
//         }
//       } else if (response.statusCode == 404) {
//         throw Exception('No warehousess found matching search criteria');
//       } else if (response.statusCode == 400) {
//         throw Exception('Invalid search parameters');
//       } else if (response.statusCode == 403) {
//         throw Exception('Access forbidden');
//       } else if (response.statusCode == 500) {
//         throw Exception('Internal server error');
//       } else if (ApiHelper.isUnauthorized(response)) {
//         throw Exception('Unauthorized');
//       } else {
//         throw Exception('Failed to search warehousess: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Search warehousess error: $e');
//       rethrow;
//     }
//   }
// }
}