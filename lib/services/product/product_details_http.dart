import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:milk_content_analysis/constants/constants.dart';
import 'package:milk_content_analysis/services/auth/auth_service.dart';

import '../../model/product_details_model.dart';
import '../../utils/api_helper.dart';

class ProductDetailsService {
  final AuthService _authService = AuthService();

  Future<List<ProductDetails>> getProductDetails() async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: getProductDetail,
      );
      final headers = await _authService.getAuthHeaders();

      final response = await http.get(uri, headers: headers);

      debugPrint('Get products details request sent to: $uri');
      debugPrint('Get product details status code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint('Get products details response: $data');

        if (data is List) {
          return data.map((json) => ProductDetails.fromJson(json)).toList();
        } else if (data['success'] == true) {
          final List<dynamic> productDetailsJson = data['productDetails'];
          return productDetailsJson.map((json) => ProductDetails.fromJson(json)).toList();
        } else if (data is Map && data.containsKey('productDetails')) {
          final List<dynamic> productDetailsJson = data['productDetails'];
          return productDetailsJson.map((json) => ProductDetails.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load products');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Product details not found');
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
        throw Exception('Failed to load products details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Get Product Details error: $e');
      rethrow;
    }
  }

// In ProductDetailsService, update getProductDetailsByProductId method:
Future<ProductDetails> getProductDetailsByProductId(int productId) async {
  try {
    final uri = Uri(
      scheme: httpScheme,
      host: API_URL,
      port: portNo,
      path: '$getProductdetaailsByProductId/$productId',
    );
    final headers = await _authService.getAuthHeaders();

    final response = await http.get(uri, headers: headers);

    debugPrint('Get product details by product ID request sent to: $uri');
    debugPrint('Get Product details by product ID Status Code: ${response.statusCode}');
    debugPrint('Get product details by product ID response: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        if (data['success'] == true) {
          if (data.containsKey('productDetails')) {
            return ProductDetails.fromJson(data['productDetails']);
          } else {
            return ProductDetails.fromJson(data);
          }
        } else {
          throw Exception(data['message'] ?? 'Failed to load product details');
        }
      } else {
        throw Exception('Invalid response format');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Product details not found for product ID: $productId');
    } else if (response.statusCode == 400) {
      throw Exception('Bad request');
    } else if (response.statusCode == 403) {
      throw Exception('Access forbidden');
    } else if (response.statusCode == 500) {
      throw Exception('Internal server error');
    } else if (ApiHelper.isUnauthorized(response)) {
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load product details: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Get Product Details by product ID error: $e');
    rethrow;
  }
}

  Future<ProductDetails> getProductDetailsById(int detailId) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: '$getProductdetailsById/$detailId',
      );
      final headers = await _authService.getAuthHeaders();

      final response = await http.get(uri, headers: headers);

      debugPrint('Get product details by ID request send to: $uri');
      debugPrint('Get Product details by ID Status Code: ${response.statusCode}');
      debugPrint('Get product details by ID response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map<String, dynamic> &&
         data['success'] == true  &&
         data.containsKey('productDetails')
          ) {
          return ProductDetails.fromJson(data);
        } else {
          throw Exception('Invalid product details data format');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Product details not found');
      } else if (response.statusCode == 400) {
        throw Exception('Bad request');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else if (ApiHelper.isUnauthorized(response)) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to load product details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Get Product Details by ID error: $e');
      rethrow;
    }
  }

  Future<ProductDetails> createProductDetails(ProductDetails productDetails) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: saveProductDetail,
      );

      final headers = await _authService.getAuthHeaders();

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(productDetails.toJson()),
      );

      debugPrint('Create Product Details request sent to: $uri');
      debugPrint('Create Product Details body: ${jsonEncode(productDetails.toJson())}');
      debugPrint('Create Product Details status code: ${response.statusCode}');
      debugPrint('Create Product Details response: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data.containsKey('productDetails')) {
          return ProductDetails.fromJson(data);
        }
        else if (data['success'] == true) {
          if (data.containsKey('productDetails')) {
            return ProductDetails.fromJson(data['productDetails']);
          } else {
            return ProductDetails.fromJson(data);
          }
        } else {
          throw Exception(data['message'] ?? 'Failed to create product details');
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Validation error');
      } else if (response.statusCode == 409) {
        throw Exception('Product details already exists');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else if (ApiHelper.isUnauthorized(response)) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to create product details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Create Product Details error: $e');
      rethrow;
    }
  }

  Future<bool> updateProductDetails(int detailId, ProductDetails productDetails) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: '$editProductDetail/$detailId',
      );
      final headers = await _authService.getAuthHeaders();

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(productDetails.toJson()),
      );

      debugPrint('Update Product Details sent to: $uri');
      debugPrint('Update Product Details body: ${jsonEncode(productDetails.toJson())}');
      debugPrint('Update Product Details status code: ${response.statusCode}');
      debugPrint('Update Product Details response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        final message = data['message']?.toString().toLowerCase() ?? '';
        return message.contains('success') || 
               message.contains('updated') || 
               (data['success'] == true);
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? data['message'] ?? 'Validation error');
      } else if (response.statusCode == 404) {
        throw Exception('Product details not found');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden');
      } else if (response.statusCode == 409) {
        throw Exception('Conflict - product details may have been modified');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else if (ApiHelper.isUnauthorized(response)) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to update Product Details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Update Product Details error: $e');
      rethrow;
    }
  }

  Future<bool> deleteProductDetails(int detailId) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: '$deleteProductDetail/$detailId',
      );

      final headers = await _authService.getAuthHeaders();

      final response = await http.delete(
        uri,
        headers: headers,
      );

      debugPrint('Delete Product Details request sent to: $uri');
      debugPrint('Delete Product Details status code: ${response.statusCode}');
      debugPrint('Delete Product Details response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        final data = response.body.isNotEmpty
            ? jsonDecode(response.body)
            : {'message': 'Product Details deleted successfully'};

        final message = data['message']?.toString().toLowerCase() ?? '';
        if (message.contains('success') || 
            message.contains('deleted') || 
            (data['success'] == true)) {
          return true;
        }
        return false;
      } else if (response.statusCode == 404) {
        throw Exception('Product details not found');
      } else if (response.statusCode == 403) {
        throw Exception('Access forbidden');
      } else if (response.statusCode == 409) {
        throw Exception('Cannot delete - product details is in use');
      } else if (response.statusCode == 500) {
        throw Exception('Internal server error');
      } else if (ApiHelper.isUnauthorized(response)) {
        throw Exception('Unauthorized');
      } else {
        throw Exception('Failed to delete Product Details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Delete Product Details error: $e');
      rethrow;
    }
  }
}