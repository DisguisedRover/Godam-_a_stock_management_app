import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/warehouses/warehouses_http.dart';
import 'warehouses_event.dart';
import 'warehouses_state.dart';


class WarehousesBloc extends Bloc<WarehousesEvent, WarehousesState> {
  final WarehousesService _warehousesService;

  WarehousesBloc({WarehousesService? warehousesService})
      : _warehousesService = warehousesService ?? WarehousesService(),
        super(WarehousesInitial()) {
    on<LoadWarehousess>(_onLoadWarehousess);
    on<LoadWarehousesById>(_onLoadWarehousesById);
    on<CreateWarehouses>(_onCreateWarehouses);
    on<UpdateWarehouses>(_onUpdateWarehouses);
    on<DeleteWarehouses>(_onDeleteWarehouses);
    
  }

  Future<void> _onLoadWarehousess(
    LoadWarehousess event,
    Emitter<WarehousesState> emit,
  ) async {
    emit(WarehousesLoading());
    try {
      final warehousess = await _warehousesService.getWarehousess();
      emit(WarehousesLoaded(warehousess));
    } catch (e) {
      emit(WarehousesError(e.toString()));
    }
  }

  Future<void> _onLoadWarehousesById(
    LoadWarehousesById event,
    Emitter<WarehousesState> emit,
  ) async {
    emit(WarehousesLoading());
    try {
      final warehouse = await _warehousesService.getWarehousesById(event.warehousesId);
      emit(WarehouseLoaded(warehouse));
    } catch (e) {
      emit(WarehousesError(e.toString()));
    }
  }

  Future<void> _onCreateWarehouses(
    CreateWarehouses event,
    Emitter<WarehousesState> emit,
  ) async {
    emit(WarehousesLoading());
    try {
      final warehouses = await _warehousesService.createWarehouses(event.warehouses);
      emit(WarehousesCreated(warehouses));
    } catch (e) {
      emit(WarehousesError(e.toString()));
    }
  }

  Future<void> _onUpdateWarehouses(
    UpdateWarehouses event,
    Emitter<WarehousesState> emit,
  ) async {
    emit(WarehousesLoading());
    try {
      final warehouses = await _warehousesService.updateWarehouses(
        event.warehousesId,
        event.warehouses,
      );
      if (warehouses) {
        final updatedWarehouses = await _warehousesService.getWarehousesById(event.warehousesId);
        emit(WarehousesUpdated(updatedWarehouses));
      } else {
        emit(const WarehousesError('Failed to update warehouses'));
      }
    } catch (e) {
      emit(WarehousesError(e.toString()));
    }
  }

  Future<void> _onDeleteWarehouses(
    DeleteWarehouses event,
    Emitter<WarehousesState> emit,
  ) async {
    emit(WarehousesLoading());
    try {
      final success = await _warehousesService.deleteWarehouses(event.warehousesId);
      if (success) {
        emit(WarehousesDeleted(event.warehousesId));
      } else {
        emit(const WarehousesError('Failed to delete warehouses'));
      }
    } catch (e) {
      emit(WarehousesError(e.toString()));
    }
  }
}