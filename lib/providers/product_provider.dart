import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/product_details_model.dart';
import '../model/product_model.dart';

class ProductProvider with ChangeNotifier {
  // State for Product List
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isProductListLoading = false;
  int _productListPage = 1;
  final int _productsPerPage = 10;
  String? _productNameFilter;
  String? _productTypeFilter;
  String? _productStatusFilter;

  // State for Product Detail List
  List<ProductDetail> _productDetails = [];
  List<ProductDetail> _filteredProductDetails = [];
  bool _isProductDetailListLoading = false;
  int _productDetailPage = 1;
  final int _productDetailsPerPage = 10;
  String? _productDetailNameFilter;
  String? _productDetailDimensionFilter;
  String? _productDetailStatusFilter;

  // Getters for Product List
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  bool get isProductListLoading => _isProductListLoading;
  int get currentProductPage => _productListPage;

  int get productListPage => _productListPage;
  int get productsPerPage => _productsPerPage;
  int get totalProducts => _products.length;
  int get totalProductPages => (_products.length / _productsPerPage).ceil();
  List<Product> get paginatedProducts {
    final startIndex = (_productListPage - 1) * _productsPerPage;
    final endIndex = startIndex + _productsPerPage;
    if (startIndex >= _filteredProducts.length) return [];
    return _filteredProducts.sublist(
      startIndex,
      endIndex > _filteredProducts.length ? _filteredProducts.length : endIndex,
    );
  }

  // Getters for Product Detail List
  List<ProductDetail> get productDetails => _productDetails;
  List<ProductDetail> get filteredProductDetails => _filteredProductDetails;
  bool get isProductDetailListLoading => _isProductDetailListLoading;
  int get currentDetailPage => _productDetailPage;

  int get productDetailPage => _productDetailPage;
  int get productDetailsPerPage => _productDetailsPerPage;
  int get totalProductDetails => _productDetails.length;

  void goToFirstDetailPage() => goToFirstProductDetailPage();
  void goToPreviousDetailPage() => goToPreviousProductDetailPage();
  void goToNextDetailPage() => goToNextProductDetailPage();
  void goToLastDetailPage() => goToLastProductDetailPage();

  int get totalProductDetailPages =>
      (_productDetails.length / _productDetailsPerPage).ceil();
  List<ProductDetail> get paginatedProductDetails {
    final startIndex = (_productDetailPage - 1) * _productDetailsPerPage;
    final endIndex = startIndex + _productDetailsPerPage;
    if (startIndex >= _filteredProductDetails.length) return [];
    return _filteredProductDetails.sublist(
      startIndex,
      endIndex > _filteredProductDetails.length
          ? _filteredProductDetails.length
          : endIndex,
    );
  }

  // Fetching data
  Future<void> fetchProducts() async {
    _isProductListLoading = true;
    notifyListeners();

    try {
      // API call placeholder
      // final response = await http.get(Uri.parse('https://your-api-endpoint.com/products'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   _products = data.map((json) => Product.fromJson(json)).toList();
      // } else {
      //   throw Exception('Failed to load products');
      // }

      // Mock data based on the image
      _products = [
        Product(
          productId: '40',
          productName: 'MARIGOLD',
          type: 'Packaging Material',
          category: null,
          subCategory: null,
          isTaxable: false,
          isKeepingStock: true,
          savedBy: 'Super Admin User',
          savedIn: '2025-07-31 11:54:36',
          status: 'Active',
        ),
        Product(
          productId: '39',
          productName: 'BUTTER',
          type: 'Semi Raw Material',
          category: null,
          subCategory: null,
          isTaxable: false,
          isKeepingStock: true,
          savedBy: 'Super Admin User',
          savedIn: '2025-07-28 10:39:47',
          status: 'Active',
        ),
        Product(
          productId: '38',
          productName: 'KRISHI CHUN',
          type: 'Raw Material',
          category: null,
          subCategory: null,
          isTaxable: false,
          isKeepingStock: true,
          savedBy: 'Super Admin User',
          savedIn: '2025-07-03 18:36:17',
          status: 'Active',
        ),
        Product(
          productId: '37',
          productName: 'DHUTO',
          type: 'Raw Material',
          category: null,
          subCategory: null,
          isTaxable: false,
          isKeepingStock: true,
          savedBy: 'Super Admin User',
          savedIn: '2025-07-03 18:35:51',
          status: 'Active',
        ),
        Product(
          productId: '36',
          productName: 'DANA MIXTURE',
          type: 'Semi Raw Material',
          category: null,
          subCategory: null,
          isTaxable: false,
          isKeepingStock: true,
          savedBy: 'Super Admin User',
          savedIn: '2025-07-03 18:29:39',
          status: 'Active',
        ),
        Product(
          productId: '35',
          productName: 'DAHI JAR',
          type: 'Packaging Material',
          category: null,
          subCategory: null,
          isTaxable: false,
          isKeepingStock: true,
          savedBy: 'Super Admin User',
          savedIn: '2025-05-31 14:16:43',
          status: 'Active',
        ),
        Product(
          productId: "34",
          productName: 'SMP',
          type: 'Raw Material',
          category: null,
          subCategory: null,
          isTaxable: false,
          isKeepingStock: true,
          savedBy: 'Super Admin User',
          savedIn: '2025-05-31 14:16:03',
          status: 'Active',
        ),
      ];
      _filteredProducts = _products;
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      _isProductListLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductDetails() async {
    _isProductDetailListLoading = true;
    notifyListeners();

    try {
      // API call placeholder
      // final response = await http.get(Uri.parse('https://your-api-endpoint.com/product-details'));
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = json.decode(response.body);
      //   _productDetails = data.map((json) => ProductDetail.fromJson(json)).toList();
      // } else {
      //   throw Exception('Failed to load product details');
      // }

      // Mock data based on the image
      _productDetails = [
        ProductDetail(
          productName: 'DANA MIXTURE',
          baseUnit: 'KG',
          derivedUnit: null,
          deriveFormula: '0.00 KG',
          dimension: '0.00 KG',
          salesRate: 0.00,
          fatRate: 0.00,
          rateAffectsDate: '2082-03-19',
          openingStock: 0.00,
          vpStock: 0.00,
          stockDate: '2082-04-01',
          savedBy: 'Super Admin User',
          savedIn: '2025-07-03 18:59:03',
          status: 'Active',
          flavour: 'Plain',
        ),
        ProductDetail(
          productName: 'DANA MIXTURE',
          baseUnit: 'KG',
          derivedUnit: null,
          deriveFormula: '30 - 50 = 0.00 KG',
          dimension: '0.00 KG',
          salesRate: 0.00,
          fatRate: 0.00,
          rateAffectsDate: '2082-03-19',
          openingStock: 0.00,
          vpStock: 0.00,
          stockDate: '2082-04-01',
          savedBy: 'Super Admin User',
          savedIn: '2025-07-03 18:58:47',
          status: 'Active',
        ),
        ProductDetail(
          productName: 'DANA MIXTURE',
          baseUnit: 'KG',
          derivedUnit: null,
          deriveFormula: '0.00 KG = 25 - 45 = 0.00 KG',
          dimension: '0.00 KG',
          salesRate: 0.00,
          fatRate: 0.00,
          rateAffectsDate: '2082-03-19',
          openingStock: 0.00,
          vpStock: 0.00,
          stockDate: '2082-04-01',
          savedBy: 'Super Admin User',
          savedIn: '2025-07-03 18:58:26',
          status: 'Active',
        ),
        ProductDetail(
          productName: 'KRISHI CHUN',
          baseUnit: 'KG',
          derivedUnit: null,
          deriveFormula: '0.00 KG',
          dimension: '0.00 KG',
          salesRate: 0.00,
          fatRate: 0.00,
          rateAffectsDate: '2082-03-19',
          openingStock: 0.00,
          vpStock: 0.00,
          stockDate: '2082-04-01',
          savedBy: 'Super Admin User',
          savedIn: '2025-07-03 18:36:34',
          status: 'Active',
        ),
        ProductDetail(
          productName: 'DHUTO',
          baseUnit: 'KG',
          derivedUnit: null,
          deriveFormula: '0.00 KG = 0.00 KG',
          dimension: '0.00 KG',
          salesRate: 0.00,
          fatRate: 0.00,
          rateAffectsDate: '2082-03-19',
          openingStock: 0.00,
          vpStock: 0.00,
          stockDate: '2082-04-01',
          savedBy: 'Super Admin User',
          savedIn: '2025-07-03 18:36:02',
          status: 'Active',
        ),
        ProductDetail(
          productName: 'NAUNI',
          baseUnit: 'PCS',
          derivedUnit: null,
          deriveFormula: 'PCS = 1000 ML',
          dimension: '425.00',
          salesRate: 0.00,
          fatRate: 0.00,
          rateAffectsDate: '2082-02-17',
          openingStock: 0.00,
          vpStock: 0.00,
          stockDate: '2082-04-01',
          savedBy: 'Super Admin User',
          savedIn: '2025-06-10 11:29:26',
          status: 'Active',
        ),
        ProductDetail(
          productName: 'DAHI JAR',
          baseUnit: 'PCS',
          derivedUnit: null,
          deriveFormula: 'PCS = 500 ML',
          dimension: '0.00',
          salesRate: 0.00,
          fatRate: 0.00,
          rateAffectsDate: '2082-02-17',
          openingStock: 0.00,
          vpStock: 0.00,
          stockDate: '2082-04-01',
          savedBy: 'Super Admin User',
          savedIn: '2025-05-31 14:17:33',
          status: 'Active',
        ),
      ];
      _filteredProductDetails = _productDetails;
    } catch (e) {
      debugPrint('Error fetching product details: $e');
    } finally {
      _isProductDetailListLoading = false;
      notifyListeners();
    }
  }

  // Saving data
  Future<void> saveProduct(Map<String, dynamic> productData) async {
    _isProductListLoading = true;
    notifyListeners();
    try {
      // API post call here
      // final response = await http.post(Uri.parse('your-api-endpoint.com/products'), body: json.encode(productData));
      // if (response.statusCode != 201) throw Exception('Failed to save product');

      // For mock data, just simulate a delay and refresh
      await Future.delayed(const Duration(seconds: 1));
      await fetchProducts();
    } catch (e) {
      rethrow;
    } finally {
      _isProductListLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProductDetail(Map<String, dynamic> productDetailData) async {
    _isProductDetailListLoading = true;
    notifyListeners();
    try {
      // API post call here
      // final response = await http.post(Uri.parse('your-api-endpoint.com/product-details'), body: json.encode(productDetailData));
      // if (response.statusCode != 201) throw Exception('Failed to save product detail');

      // For mock data, just simulate a delay and refresh
      await Future.delayed(const Duration(seconds: 1));
      await fetchProductDetails();
    } catch (e) {
      rethrow;
    } finally {
      _isProductDetailListLoading = false;
      notifyListeners();
    }
  }

  // Filtering Logic
  void filterProducts({String? name, String? type, String? status}) {
    _productNameFilter = name?.toLowerCase();
    _productTypeFilter = type?.toLowerCase();
    _productStatusFilter = status?.toLowerCase();

    _filteredProducts = _products.where((product) {
      final nameMatch =
          _productNameFilter == null ||
          product.productName.toLowerCase().contains(_productNameFilter!);
      final typeMatch =
          _productTypeFilter == null ||
          product.type.toLowerCase() == _productTypeFilter;
      final statusMatch =
          _productStatusFilter == null ||
          product.status.toLowerCase() == _productStatusFilter;
      return nameMatch && typeMatch && statusMatch;
    }).toList();
    _productListPage = 1;
    notifyListeners();
  }

  void filterProductDetails({String? name, String? dimension, String? status}) {
    _productDetailNameFilter = name?.toLowerCase();
    _productDetailDimensionFilter = dimension?.toLowerCase();
    _productDetailStatusFilter = status?.toLowerCase();

    _filteredProductDetails = _productDetails.where((detail) {
      final nameMatch =
          _productDetailNameFilter == null ||
          detail.productName.toLowerCase().contains(_productDetailNameFilter!);
      final dimensionMatch =
          _productDetailDimensionFilter == null ||
          detail.dimension.toLowerCase().contains(
            _productDetailDimensionFilter!,
          );
      final statusMatch =
          _productDetailStatusFilter == null ||
          detail.status.toLowerCase() == _productDetailStatusFilter;
      return nameMatch && dimensionMatch && statusMatch;
    }).toList();
    _productDetailPage = 1;
    notifyListeners();
  }

  // Pagination Logic for Product List
  void goToFirstProductPage() {
    _productListPage = 1;
    notifyListeners();
  }

  void goToPreviousProductPage() {
    if (_productListPage > 1) {
      _productListPage--;
      notifyListeners();
    }
  }

  void goToNextProductPage() {
    if (_productListPage < totalProductPages) {
      _productListPage++;
      notifyListeners();
    }
  }

  void goToLastProductPage() {
    _productListPage = totalProductPages;
    notifyListeners();
  }

  // Pagination Logic for Product Detail List
  void goToFirstProductDetailPage() {
    _productDetailPage = 1;
    notifyListeners();
  }

  void goToPreviousProductDetailPage() {
    if (_productDetailPage > 1) {
      _productDetailPage--;
      notifyListeners();
    }
  }

  void goToNextProductDetailPage() {
    if (_productDetailPage < totalProductDetailPages) {
      _productDetailPage++;
      notifyListeners();
    }
  }

  void goToLastProductDetailPage() {
    _productDetailPage = totalProductDetailPages;
    notifyListeners();
  }
}
