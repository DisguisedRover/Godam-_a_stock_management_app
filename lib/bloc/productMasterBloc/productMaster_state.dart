import 'package:equatable/equatable.dart';
import '../../model/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

// Initial state
class ProductInitial extends ProductState {}

// Loading state
class ProductLoading extends ProductState {}

// Products loaded successfully
class ProductsLoaded extends ProductState {
  final List<Product> products;

  const ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

// Single product loaded successfully
class ProductLoaded extends ProductState {
  final Product product;

  const ProductLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

// Product created successfully
class ProductCreated extends ProductState {
  final Product product;

  const ProductCreated(this.product);

  @override
  List<Object?> get props => [product];
}

// Product updated successfully
class ProductUpdated extends ProductState {
  final Product product;

  const ProductUpdated(this.product);

  @override
  List<Object?> get props => [product];
}

// Product deleted successfully
class ProductDeleted extends ProductState {
  final int productId;

  const ProductDeleted(this.productId);

  @override
  List<Object?> get props => [productId];
}

// Error state
class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}