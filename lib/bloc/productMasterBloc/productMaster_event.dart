import 'package:equatable/equatable.dart';
import '../../model/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

// Load all products
class LoadProducts extends ProductEvent {}

// Load a single product by ID
class LoadProductById extends ProductEvent {
  final int productId;

  const LoadProductById(this.productId);

  @override
  List<Object?> get props => [productId];
}

// Create a new product
class CreateProduct extends ProductEvent {
  final Product product;

  const CreateProduct(this.product);

  @override
  List<Object?> get props => [product];
}

// Update an existing product
class UpdateProduct extends ProductEvent {
  final int productId;
  final Product product;

  const UpdateProduct(this.productId, this.product);

  @override
  List<Object?> get props => [productId, product];
}

// Delete a product
class DeleteProduct extends ProductEvent {
  final int productId;

  const DeleteProduct(this.productId);

  @override
  List<Object?> get props => [productId];
}

// Search/Filter products
class SearchProducts extends ProductEvent {
  final String? category;
  final String? type;
  final String? status;

  const SearchProducts({this.category, this.type, this.status});

  @override
  List<Object?> get props => [category, type, status];
}