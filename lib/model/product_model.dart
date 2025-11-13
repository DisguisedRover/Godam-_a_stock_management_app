class Product {
  final int? productId;
  final String productName;
  final String type;
  final String category;
  final String? subCategory;
  final String isTaxable;
  final String isKeepingStock;
  final int? savedBy;
  final DateTime savedIn;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int? deletedBy;
  final int? categoryId;

  Product({
    this.productId,
    required this.productName,
    required this.type,
    required this.category,
    this.subCategory,
    required this.isTaxable,
    required this.isKeepingStock,
    this.savedBy,
    required this.savedIn,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.deletedBy,
    this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      type: json['type'],
      category: json['category'],
      subCategory: json['subCategory'],
      isTaxable: json['isTaxable'],
      isKeepingStock: json['isKeepingStock'],
      savedBy: json['savedBy'],
      savedIn: DateTime.parse(json['savedIn']),
      status: json['status'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      deletedAt: json['deleted_at'] != null 
          ? DateTime.parse(json['deleted_at']) 
          : null,
      deletedBy: json['deleted_by'],
      categoryId: json['category_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (productId != null) 'product_id': productId,
      'product_name': productName,
      'type': type,
      'category': category,
      if (subCategory != null && subCategory!.isNotEmpty) 
        'subCategory': subCategory,
      'isTaxable': isTaxable,
      'isKeepingStock': isKeepingStock,
      if (savedBy != null) 'savedBy': savedBy,
      'savedIn': savedIn.toIso8601String().split('T')[0],
      'status': status,
      if (categoryId != null) 'category_id': categoryId,
    };
  }

  Product copyWith({
    int? productId,
    String? productName,
    String? type,
    String? category,
    String? subCategory,
    String? isTaxable,
    String? isKeepingStock,
    int? savedBy,
    DateTime? savedIn,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? deletedBy,
    int? categoryId,
  }) {
    return Product(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      type: type ?? this.type,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      isTaxable: isTaxable ?? this.isTaxable,
      isKeepingStock: isKeepingStock ?? this.isKeepingStock,
      savedBy: savedBy ?? this.savedBy,
      savedIn: savedIn ?? this.savedIn,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}