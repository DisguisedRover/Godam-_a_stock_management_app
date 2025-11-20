import 'package:equatable/equatable.dart';
import '../../model/product_details_model.dart';

abstract class ProductDetailsEvent extends Equatable {
  const ProductDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetails extends ProductDetailsEvent{}

class LoadProductDetailsById extends ProductDetailsEvent{
  final int productDetailsId;

  const LoadProductDetailsById(this.productDetailsId);

  @override
  List<Object?> get props => [productDetailsId];
 }


class LoadProductDetailsByProductId extends ProductDetailsEvent{
  final int productId;

  const LoadProductDetailsByProductId(this.productId);

  @override
  List<Object?> get props => [productId];
}
class CreateProductDetails extends ProductDetailsEvent{
      final ProductDetails productDetails;
      
      const CreateProductDetails(this.productDetails);

      @override
      List<Object?> get props => [productDetails];
}

class UpdateProductDetails extends ProductDetailsEvent{
  final int productDetailsId;
  final ProductDetails productDetails;

  const UpdateProductDetails(this.productDetailsId, this.productDetails);

  @override
  List<Object?> get props => [productDetailsId, productDetails];
}

class DeleteProductDetails extends ProductDetailsEvent {
  final int productDetailId;

  const DeleteProductDetails(this.productDetailId);

  @override
  List<Object?> get props => [productDetailId];
}


class SearchProductDetails extends ProductDetailsEvent{
  final String? salesRate;
  final String? baseUnit;
  final String? derivedUint;

  const SearchProductDetails({this.baseUnit, this.derivedUint, this.salesRate});

  @override
  List<Object?> get props => [baseUnit, derivedUint, salesRate];
}