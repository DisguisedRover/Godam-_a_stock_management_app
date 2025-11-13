import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/product_master/product_master_http.dart';
import 'productMaster_event.dart';
import 'productMaster_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService _productService;

  ProductBloc({ProductService? productService})
      : _productService = productService ?? ProductService(),
        super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<CreateProduct>(_onCreateProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<SearchProducts>(_onSearchProducts);
  }

  // Load all products
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productService.getProducts();
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // Load a single product by ID
  Future<void> _onLoadProductById(
    LoadProductById event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _productService.getProductById(event.productId);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // Create a new product
  Future<void> _onCreateProduct(
    CreateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _productService.createProduct(event.product);
      emit(ProductCreated(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // Update an existing product
  Future<void> _onUpdateProduct(
    UpdateProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final product = await _productService.updateProduct(
        event.productId,
        event.product,
      );
      emit(ProductUpdated(product));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // Delete a product
  Future<void> _onDeleteProduct(
    DeleteProduct event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final success = await _productService.deleteProduct(event.productId);
      if (success) {
        emit(ProductDeleted(event.productId));
      } else {
        emit(const ProductError('Failed to delete product'));
      }
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  // Search/Filter products
  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await _productService.searchProducts(
        category: event.category,
        type: event.type,
        status: event.status,
      );
      emit(ProductsLoaded(products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }
}