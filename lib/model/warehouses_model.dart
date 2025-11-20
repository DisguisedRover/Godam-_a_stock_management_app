class Warehouses {
  final int? warehouseId;
  final String name;
  final String location;
  final int? managerId;
  final double? capacity;
  final bool isActive;
  final int savedBy;
  final DateTime? deletedAt;
  final int? deletedBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Warehouses({
    required this.warehouseId,
    required this.name,
    required this.location,
    this.managerId,
    this.capacity,
    required this.isActive,
    required this.savedBy,
    this.deletedAt,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
  });
  factory Warehouses.fromJson(Map<String, dynamic> json) {
    return Warehouses(
      warehouseId: json['warehouse_id'],
      name: json['name'],
      location: json['location'],
      managerId: json['manager_id'],
      capacity: json['capacity'] != null ? double.tryParse(json['capacity'].toString()) : null,
      isActive: json['is_active'] ?? true,
      savedBy: json['savedBy'],
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at']) : null,
      deletedBy: json['deleted_by'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warehouse_id': warehouseId,
      'name': name,
      'location': location,
      'manager_id': managerId,
      'capacity': capacity,
      'is_active': isActive,
      'savedBy': savedBy,
      'deleted_at': deletedAt?.toIso8601String(),
      'deleted_by': deletedBy,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Warehouses copyWith({
    int? warehouseId,
    String? name,
    String? location,
    int? managerId,
    double? capacity,
    bool? isActive,
    int? savedBy,
    DateTime? deletedAt,
    int? deletedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Warehouses(
      warehouseId: warehouseId ?? this.warehouseId,
      name: name ?? this.name,
      location: location ?? this.location,
      managerId: managerId ?? this.managerId,
      capacity: capacity ?? this.capacity,
      isActive: isActive ?? this.isActive,
      savedBy: savedBy ?? this.savedBy,
      deletedAt: deletedAt ?? this.deletedAt,
      deletedBy: deletedBy ?? this.deletedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}