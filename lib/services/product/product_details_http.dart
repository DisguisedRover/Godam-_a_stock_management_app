import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:milk_content_analysis/constants/constants.dart';
import 'package:milk_content_analysis/services/auth_service.dart';

import '../../model/product_details_model.dart';

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

            if (data is List){
              return data.map((json) => ProductDetails.fromJson(json)).toList();
            }else if (data['success'] == true) {
              final List<dynamic> productDetailsJson = data ['productDetails'];
              return productDetailsJson.map((json) => ProductDetails.fromJson(json)).toList();
            }else if ( data is Map && data.containsKey('productDetails')) {

              final List<dynamic> productDetailsJson = data ['productDetials'];
              return productDetailsJson.map((json) => ProductDetails.fromJson(json)).toList();
            }
            else {
              throw Exception(data['message'] ?? 'Failed to load products');
            }
          }else {
              throw Exception('Failed to load products details: ${response.statusCode}');
            }
          }
          catch (e){
            debugPrint('Get Product Details error: $e');
            rethrow;
          }
        }

    Future<ProductDetails> getProductDetailsById(int detailId) async {
      try{
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
        debugPrint('Get product detials by ID response: ${response.body}');

        if (response.statusCode == 200){
          final data = jsonDecode(response.body);

          if (data is  Map<String, dynamic> && data.containsKey('detail_id')){
            return ProductDetails.fromJson(data);
          }else{
            throw Exception('Invalid product details data format');
          }
        } else if (response.statusCode == 404) {
          throw Exception ('Product details not found');
        } else {
          throw Exception ('Failed to load products: ${response.statusCode}');
        }
      } 
      catch(e){
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

        debugPrint('Create Product Details requeset sent to: $uri');
        debugPrint('Create Product Details body: ${response.body}');
        debugPrint('Create Porduct Details status code: ${response.statusCode}');

        if (response.statusCode == 201 || response.statusCode == 200){
          final data = jsonDecode(response.body);
          debugPrint('Create Product Details response: $data');

          if (data['success'] == true) { 
            return ProductDetails.fromJson(data['productDetails']);
          } else{
              throw Exception(data['message'] ?? 'Failed to create product details');
          }
        } else if (response.statusCode == 400) {
          final data = jsonDecode(response.body);
          throw Exception (data['message'] ?? 'Validation error');
        } else {
          throw Exception ('Failed to create prodct details: ${response.statusCode}');
        }
      }
      catch (e){
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
        debugPrint('Update Product Details body: ${response.body}');
        debugPrint('Update Product Details status code: ${response.statusCode}');

        if (response.statusCode == 200){

          final data = jsonDecode(response.body);
          debugPrint('Update Product Details response: $data');

          final message = data['message']?.toString().toLowerCase() ?? '';
          return message.contains('success') || message.contains('updated');
        }else if (response.statusCode == 400){
          final data = jsonDecode(response.body);
          throw Exception(data['error'] ?? data['message'] ?? 'Validation error');
        }else{
          throw Exception('Failed to update Product Details: ${response.statusCode}');
        }
      }
      catch (e){
        debugPrint('Update Product Details error: $e');
        rethrow;
      }
    }

    Future<bool> deleteProductDetails(int detailId) async {
        try{
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

            if(response.statusCode == 200 || response.statusCode == 204) {
              final data = response.body.isNotEmpty
                ?jsonDecode(response.body)
                :{'message': 'Product Details deleted successfully'};
              debugPrint('Delete Product Details response: $data');


              final message = data['message']?.toString().toLowerCase() ?? '';
              if(message.contains('success') || message.contains('deleted')) {
                return true;
              }
              return false;
            }else{
              throw Exception('Failed to delete Product Details: ${response.statusCode}');
            }

        }
        catch (e){
          debugPrint('Delete Product Details error: $e');
          rethrow;
        }
    }
}