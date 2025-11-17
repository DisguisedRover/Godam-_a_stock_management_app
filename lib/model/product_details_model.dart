class ProductDetails {
  final int detailId;
  final int productId;
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
  final DateTime? savedIn;
  final String? flavour;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductDetails({
    required this.detailId,
    required this.productId,
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
    return ProductDetails(
      detailId: _parseInt(json['detail_id']),
      productId: _parseInt(json['product_id']),
      baseUnit: json['baseUnit']?.toString() ?? '',
      derivedUnit: json['derivedUnit']?.toString() ?? '',
      deriveFormula: json['deriveFormula']?.toString() ?? '',
      dimension: json['dimension']?.toString() ?? '',
      salesRate: _parseDouble(json['salesRate']),
      fatRate: _parseDouble(json['fatRate']),
      date: json['rateAffectsDate'] != null 
          ? DateTime.tryParse(json['rateAffectsDate'].toString()) 
          : (json['date'] != null 
              ? DateTime.tryParse(json['date'].toString()) 
              : null),
      openingStock: _parseDouble(json['openingStock']),
      stockDate: json['stockDate'] != null 
          ? DateTime.tryParse(json['stockDate'].toString()) 
          : null,
      savedBy: json['savedBy'] != null ? _parseInt(json['savedBy']) : null,
      savedIn: json['savedIn'] != null 
          ? DateTime.tryParse(json['savedIn'].toString()) 
          : null,
      flavour: json['flavour']?.toString(),
      createdAt: json['created_at'] != null 
          ? DateTime.tryParse(json['created_at'].toString()) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.tryParse(json['updated_at'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'detail_id': detailId,
      'product_id': productId,
      'baseUnit': baseUnit,
      'derivedUnit': derivedUnit,
      'deriveFormula': deriveFormula,
      'dimension': dimension,
      'salesRate': salesRate,
      'fatRate': fatRate,
      'rateAffectsDate': date?.toIso8601String(),
      'openingStock': openingStock,
      'stockDate': stockDate?.toIso8601String(),
      'savedBy': savedBy,
      'savedIn': savedIn?.toIso8601String(),
      'flavour': flavour,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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