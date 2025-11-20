class ProductDetails {
  final int detailId;
  final int productId;
  final String? productName;
  final String baseUnit;
  final String derivedUnit;
  final String deriveFormula;
  final String dimension;
  final double salesRate;
  final double fatRate;
  final DateTime? date;
  final double openingStock;
  final DateTime? stockDate;
  final int? savedBy;
  final String? savedByUsername;
  final DateTime? savedIn;
  final String? flavour;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductDetails({
    required this.detailId,
    required this.productId,
    this.productName,  
    required this.baseUnit,
    required this.derivedUnit,
    required this.deriveFormula,
    required this.dimension,
    required this.salesRate,
    required this.fatRate,
    this.date,
    required this.openingStock,
    this.stockDate,
    this.savedBy,
    this.savedByUsername, 
    this.savedIn,
    this.flavour,
    this.createdAt,
    this.updatedAt,
  });

  static double _parseDouble(dynamic value, {double defaultValue = 0.0}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

  static int _parseInt(dynamic value, {int defaultValue = 0}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value) ?? defaultValue;
    }
    return defaultValue;
  }

factory ProductDetails.fromJson(Map<String, dynamic> json) {
  Map<String, dynamic> data = json;
  if (json.containsKey('productDetails') && json['productDetails'] is Map<String, dynamic>) {
    data = json['productDetails'];
  }
  
  return ProductDetails(
    detailId: _parseInt(data['detail_id'] ?? data['id']),
    productId: _parseInt(data['product_id']),
    productName: json['product_name']?.toString(),
    baseUnit: data['baseUnit']?.toString() ?? '',
    derivedUnit: data['derivedUnit']?.toString() ?? '',
    deriveFormula: data['deriveFormula']?.toString() ?? '',
    dimension: data['dimension']?.toString() ?? '',
    salesRate: _parseDouble(data['salesRate']),
    fatRate: _parseDouble(data['fatRate']),
    date: data['rateAffectsDate'] != null 
        ? DateTime.tryParse(data['rateAffectsDate'].toString()) 
        : (data['date'] != null 
            ? DateTime.tryParse(data['date'].toString()) 
            : null),
    openingStock: _parseDouble(data['openingStock']),
    stockDate: data['stockDate'] != null 
        ? DateTime.tryParse(data['stockDate'].toString()) 
        : null,
    savedBy: data['savedBy'] != null ? _parseInt(data['savedBy']) : null,
    savedByUsername: json['saved_by_username']?.toString(),
    savedIn: data['savedIn'] != null 
        ? DateTime.tryParse(data['savedIn'].toString()) 
        : null,
    flavour: data['flavour']?.toString(),
    createdAt: data['created_at'] != null 
        ? DateTime.tryParse(data['created_at'].toString()) 
        : null,
    updatedAt: data['updated_at'] != null 
        ? DateTime.tryParse(data['updated_at'].toString()) 
        : null,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'baseUnit': baseUnit,
      'derivedUnit': derivedUnit,
      'deriveFormula': deriveFormula,
      'dimension': dimension,
      'salesRate': salesRate,
      'fatRate': fatRate,
      'rateAffectsDate': date != null ? _formatDate(date!) : null,
      'openingStock': openingStock,
      'stockDate': stockDate != null ? _formatDate(stockDate!) : null,
      'savedIn': savedIn != null ? _formatDate(savedIn!) : null,
      'flavour': flavour,
    };
  }

  ProductDetails copyWith({
    int? detailId,
    int? productId,
    String? baseUnit,
    String? derivedUnit,
    String? deriveFormula,
    String? dimension,
    double? salesRate,
    double? fatRate,
    DateTime? date,
    double? openingStock,
    DateTime? stockDate,
    int? savedBy,
    DateTime? savedIn,
    String? flavour,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductDetails(
      detailId: detailId ?? this.detailId,
      productId: productId ?? this.productId,
      baseUnit: baseUnit ?? this.baseUnit,
      derivedUnit: derivedUnit ?? this.derivedUnit,
      deriveFormula: deriveFormula ?? this.deriveFormula,
      dimension: dimension ?? this.dimension,
      salesRate: salesRate ?? this.salesRate,
      fatRate: fatRate ?? this.fatRate,
      date: date ?? this.date,
      openingStock: openingStock ?? this.openingStock,
      stockDate: stockDate ?? this.stockDate,
      savedBy: savedBy ?? this.savedBy,
      savedIn: savedIn ?? this.savedIn,
      flavour: flavour ?? this.flavour,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'ProductDetails(detailId: $detailId, productId: $productId, baseUnit: $baseUnit, derivedUnit: $derivedUnit, salesRate: $salesRate, fatRate: $fatRate, openingStock: $openingStock)';
  }
 
}

 String _formatDate(DateTime dateTime) {
  return '${dateTime.year.toString().padLeft(4, '0')}-'
      '${dateTime.month.toString().padLeft(2, '0')}-'
      '${dateTime.day.toString().padLeft(2, '0')} '
      '${dateTime.hour.toString().padLeft(2, '0')}:'
      '${dateTime.minute.toString().padLeft(2, '0')}:'
      '${dateTime.second.toString().padLeft(2, '0')}';
}