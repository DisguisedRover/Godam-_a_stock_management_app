import 'package:equatable/equatable.dart';

import '../../model/warehouses_model.dart';

abstract class WarehousesEvent extends Equatable {
  const WarehousesEvent();

  @override
  List<Object?> get props => [];
}

class LoadWarehousess extends WarehousesEvent {}

class LoadWarehousesById extends WarehousesEvent {
  final int warehousesId;

  const LoadWarehousesById(this.warehousesId);

  @override
  List<Object?> get props => [warehousesId];
}

class CreateWarehouses extends WarehousesEvent {
  final Warehouses warehouses;

  const CreateWarehouses(this.warehouses);

  @override
  List<Object?> get props => [warehouses];
}

class UpdateWarehouses extends WarehousesEvent {
  final int warehousesId;
  final Warehouses warehouses;

  const UpdateWarehouses(this.warehousesId, this.warehouses);

  @override
  List<Object?> get props => [warehousesId, warehouses];
}

class DeleteWarehouses extends WarehousesEvent {
  final int warehousesId;

  const DeleteWarehouses(this.warehousesId);

  @override
  List<Object?> get props => [warehousesId];
}
