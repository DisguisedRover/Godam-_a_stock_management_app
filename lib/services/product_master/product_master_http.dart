
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../constants/constants.dart';
import '../../model/product_model.dart';
import '../auth_service.dart';

class ProductService {
  final AuthService _authService = AuthService();

  Future<List<Product>> getProducts() async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: getProduct,
      );

      final headers = await _authService.getAuthHeaders();
    
      final response = await http.get(uri, headers: headers);

      debugPrint("Get products request sent to: $uri");
      debugPrint("Get products status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Get products response: $data");

        if (data['success'] == true) {
          final List<dynamic> productsJson = data['products'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to load products');
        }
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Get products error: $e');
      rethrow;
    }
  }

  Future<Product> getProductById(int productId) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: '$getProductbyId/$productId', 
      );

      final headers = await _authService.getAuthHeaders();

      final response = await http.get(uri, headers: headers);

      debugPrint("Get product by ID request sent to: $uri");
      debugPrint("Get product status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Get product response: $data");

        if (data['success'] == true) {
          return Product.fromJson(data['product']);
        } else {
          throw Exception(data['message'] ?? 'Failed to load product');
        }
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Get product by ID error: $e');
      rethrow;
    }
  }

  Future<Product> createProduct(Product product) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: saveProduct,
      );

      final headers = await _authService.getAuthHeaders();

      final response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(product.toJson()),
      );

      debugPrint("Create product request sent to: $uri");
      debugPrint("Create product body: ${product.toJson()}");
      debugPrint("Create product status code: ${response.statusCode}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Create product response: $data");

        if (data['success'] == true) {
          return Product.fromJson(data['product']);
        } else {
          throw Exception(data['message'] ?? 'Failed to create product');
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Validation error');
      } else {
        throw Exception('Failed to create product: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Create product error: $e');
      rethrow;
    }
  }

  Future<Product> updateProduct(int productId, Product product) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: '$editProduct/$productId',
      );

      final headers = await _authService.getAuthHeaders();

      final response = await http.put(
        uri,
        headers: headers,
        body: jsonEncode(product.toJson()),
      );

      debugPrint("Update product request sent to: $uri");
      debugPrint("Update product body: ${product.toJson()}");
      debugPrint("Update product status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Update product response: $data");

        if (data['success'] == true) {
          return Product.fromJson(data['product']);
        } else {
          throw Exception(data['message'] ?? 'Failed to update product');
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Validation error');
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Update product error: $e');
      rethrow;
    }
  }

  Future<bool> deleteProduct(int productId) async {
    try {
      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: '$deleteproduct/$productId',
      );

      final headers = await _authService.getAuthHeaders();
      headers['ngrok-skip-browser-warning'] = 'true';

      final response = await http.delete(uri, headers: headers);

      debugPrint("Delete product request sent to: $uri");
      debugPrint("Delete product status code: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 204) {
        final data = response.body.isNotEmpty 
            ? jsonDecode(response.body) 
            : {'success': true};
        debugPrint("Delete product response: $data");

        return data['success'] == true;
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Delete product error: $e');
      rethrow;
    }
  }

  Future<List<Product>> searchProducts({
    String? category,
    String? type,
    String? status,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (category != null) queryParams['category'] = category;
      if (type != null) queryParams['type'] = type;
      if (status != null) queryParams['status'] = status;

      final uri = Uri(
        scheme: httpScheme,
        host: API_URL,
        port: portNo,
        path: '/api/products/search',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      final headers = await _authService.getAuthHeaders();

      final response = await http.get(uri, headers: headers);

      debugPrint("Search products request sent to: $uri");
      debugPrint("Search products status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Search products response: $data");

        if (data['success'] == true) {
          final List<dynamic> productsJson = data['products'];
          return productsJson.map((json) => Product.fromJson(json)).toList();
        } else {
          throw Exception(data['message'] ?? 'Failed to search products');
        }
      } else {
        throw Exception('Failed to search products: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Search products error: $e');
      rethrow;
    }
  }
}