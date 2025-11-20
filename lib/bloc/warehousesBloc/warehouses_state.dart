import 'package:equatable/equatable.dart';
import '../../model/warehouses_model.dart';

abstract class WarehousesState extends Equatable {
  const WarehousesState();

  @override
  List<Object?> get props => [];
}

class WarehousesInitial extends WarehousesState {}

class WarehousesLoading extends WarehousesState {}

class WarehousesLoaded extends WarehousesState {
  final List<Warehouses> warehouses;

  const WarehousesLoaded(this.warehouses);

  @override
  List<Object?> get props => [warehouses];
}

class WarehouseLoaded extends WarehousesState {
  final Warehouses warehouse;

  const WarehouseLoaded(this.warehouse);

  @override
  List<Object?> get props => [warehouse];
}

class WarehousesCreated extends WarehousesState {
  final Warehouses warehouses;

  const WarehousesCreated(this.warehouses);

  @override
  List<Object?> get props => [warehouses];
}

class WarehousesUpdated extends WarehousesState {
  final Warehouses warehouse;

  const WarehousesUpdated(this.warehouse);

  @override
  List<Object?> get props => [warehouse];
}

class WarehousesDeleted extends WarehousesState {
  final int warehousesId;

  const WarehousesDeleted(this.warehousesId);

  @override
  List<Object?> get props => [warehousesId];
}

class WarehousesError extends WarehousesState {
  final String message;

  const WarehousesError(this.message);

  @override
  List<Object?> get props => [message];
}