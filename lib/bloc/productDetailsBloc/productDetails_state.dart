import 'package:equatable/equatable.dart';

import '../../model/product_details_model.dart';

abstract class ProductDetailsState extends Equatable {
  const ProductDetailsState();

  @override
  List<Object?> get props => [];
}

class ProductDetailsInitial extends ProductDetailsState{}

class ProductDetailsLoading extends ProductDetailsState{}

class ProductDetailsLoaded extends ProductDetailsState{
  final List<ProductDetails> productDetails;

  const ProductDetailsLoaded(this.productDetails);

  @override
  List<Object?> get props => [productDetails];
}

class ProdcutDetailLoaded extends ProductDetailsState{
  final ProductDetails productDetails;

  const ProdcutDetailLoaded(this.productDetails);

  @override
  List<Object?> get props => [productDetails];
}

class ProductDetailsCreated extends ProductDetailsState {
  final ProductDetails productDetails;

  const ProductDetailsCreated(this.productDetails);

  @override
  List<Object?> get props => [productDetails];
}

class ProductDetailsUpdated extends ProductDetailsState{
  final ProductDetails productDetails;

  const ProductDetailsUpdated(this.productDetails);

  @override
  List<Object?> get props => [productDetails];
}

class ProductDetailsDeleted extends ProductDetailsState {
  final ProductDetails productDetailsId;

  const ProductDetailsDeleted(this.productDetailsId);

  @override
  List<Object?> get props => [productDetailsId];
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}