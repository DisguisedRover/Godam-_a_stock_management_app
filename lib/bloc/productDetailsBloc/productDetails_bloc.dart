import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:milk_content_analysis/model/product_details_model.dart';

import '../../services/product/product_details_http.dart';
import 'productDetails_event.dart';
import 'productDetails_state.dart';

class ProductDetailsBloc extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  final ProductDetailsService _productDetailsService;

  ProductDetailsBloc({ProductDetailsService? productDetailsService})
      : _productDetailsService = productDetailsService ?? ProductDetailsService(),
      super(ProductDetailsInitial()) {
        on<LoadProductDetails>(_onLoadProductDetails);
        on<LoadProductDetailsByProductId>(_onLoadProductDetailsByProductId);
        on<LoadProductDetailsById>(_onLoadProductDetailsById);
        on<CreateProductDetails>(_onCreateProductDetails);
        on<UpdateProductDetails>(_onUpdateProductDetails);
        on<DeleteProductDetails>(_onDeleteProductDetails);
        
      }


  Future<void> _onLoadProductDetails(
      LoadProductDetails event,
      Emitter<ProductDetailsState> emit,
    ) async {
        emit(ProductDetailsLoading());
        try {

          final productDetails = await _productDetailsService.getProductDetails();
          emit(ProductDetailsLoaded(productDetails));
        } catch (e) {
          emit(ProductDetailsError(e.toString()));
        }

    }
  Future<void> _onLoadProductDetailsByProductId(
    LoadProductDetailsByProductId event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final productDetail = await _productDetailsService.getProductDetailsByProductId(event.productId);
      emit(ProductDetailLoaded(productDetail));
    }catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  Future<void> _onLoadProductDetailsById(
    LoadProductDetailsById event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final productDetail = await _productDetailsService.getProductDetailsById(event.productDetailsId);
      emit(ProductDetailLoaded(productDetail));
    }catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  Future<void> _onCreateProductDetails(
    CreateProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final productDetails = await _productDetailsService.createProductDetails(event.productDetails);
      emit(ProductDetailsCreated(productDetails));
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  Future<void> _onUpdateProductDetails(
    UpdateProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final productDetails = await _productDetailsService.updateProductDetails(
        event.productDetailsId,
        event.productDetails,
      );
     if (productDetails) {
      final updatedProductDetails = await _productDetailsService.getProductDetailsById(event.productDetailsId);
      emit(ProductDetailsUpdated(updatedProductDetails));
    } else {
      emit(const ProductDetailsError('Failed to update product details'));
    }
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  Future<void> _onDeleteProductDetails(
    DeleteProductDetails event,
    Emitter<ProductDetailsState> emit,
  ) async {
    emit(ProductDetailsLoading());
    try {
      final success = await _productDetailsService.deleteProductDetails(event.productDetailId);
      if (success) {
        emit(ProductDetailsDeleted(event.productDetailId as ProductDetails));
      } else {
        emit(const ProductDetailsError('Failed to delete product'));
      }
    } catch (e) {
      emit(ProductDetailsError(e.toString()));
    }
  }

  // Future<void> _onSearchProductDetails(
  //   SearchProductDetails event,
  //   Emitter<ProductDetailsState> emit,
  // ) async {
  //   emit(ProductDetailsLoading());
  //   try {
  //     final products = await _productDetailsService.searchProducctDetails(
  //       category: event.category,
  //       type: event.type,
  //       status: event.status,
  //     );
  //     emit(ProductsLoaded(products));
  //   } catch (e) {
  //     emit(ProductError(e.toString()));
  //   }
  // }

}