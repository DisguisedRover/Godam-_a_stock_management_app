class Product {
  final String productId;
  final String productName;
  final String type;
  final String? category;
  final String? subCategory;
  final bool isTaxable;
  final bool isKeepingStock;
  final String savedBy;
  final String savedIn;
  final String status;

  Product({
    required this.productId,
    required this.productName,
    required this.type,
    this.category,
    this.subCategory,
    required this.isTaxable,
    required this.isKeepingStock,
    required this.savedBy,
    required this.savedIn,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['productId'],
      productName: json['productName'],
      type: json['type'],
      category: json['category'],
      subCategory: json['subCategory'],
      isTaxable: json['isTaxable'] == 1,
      isKeepingStock: json['isKeepingStock'] == 1,
      savedBy: json['savedBy'],
      savedIn: json['savedIn'],
      status: json['status'],
    );
  }
}
