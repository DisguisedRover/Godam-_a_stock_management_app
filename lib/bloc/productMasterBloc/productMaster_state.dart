import 'package:equatable/equatable.dart';
import '../../model/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductLoaded extends ProductState {
  final Product product;

  const ProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductCreated extends ProductState {
  final Product product;

  const ProductCreated(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductUpdated extends ProductState {
  final Product product;

  const ProductUpdated(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductDeleted extends ProductState {
  final int productId;

  const ProductDeleted(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}