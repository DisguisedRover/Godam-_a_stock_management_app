class ProductDetail {
  final String productName;
  final String baseUnit;
  final String? derivedUnit;
  final String? deriveFormula;
  final String dimension;
  final double salesRate;
  final double fatRate;
  final String rateAffectsDate;
  final double openingStock;
  final double? vpStock;
  final String stockDate;
  final String savedBy;
  final String savedIn;
  final String status;
  final String? flavour;

  ProductDetail({
    required this.productName,
    required this.baseUnit,
    this.derivedUnit,
    this.deriveFormula,
    required this.dimension,
    required this.salesRate,
    required this.fatRate,
    required this.rateAffectsDate,
    required this.openingStock,
    this.vpStock,
    required this.stockDate,
    required this.savedBy,
    required this.savedIn,
    required this.status,
    this.flavour,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      productName: json['productName'],
      baseUnit: json['baseUnit'],
      derivedUnit: json['derivedUnit'],
      deriveFormula: json['deriveFormula'],
      dimension: json['dimension'],
      salesRate: json['salesRate'].toDouble(),
      fatRate: json['fatRate'].toDouble(),
      rateAffectsDate: json['rateAffectsDate'],
      openingStock: json['openingStock'].toDouble(),
      // vpStock: json['vpStock'].toDouble(),
      stockDate: json['stockDate'],
      savedBy: json['savedBy'],
      savedIn: json['savedIn'],
      status: json['status'],
      flavour: json['flavour'],
    );
  }
}
