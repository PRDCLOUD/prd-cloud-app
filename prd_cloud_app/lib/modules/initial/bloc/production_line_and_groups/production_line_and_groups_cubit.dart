import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:error_repository/error_repository.dart';
import 'package:meta/meta.dart';
import 'package:models/models.dart';
import 'package:production_data_repository/production_data_repository.dart';


part 'production_line_and_groups_state.dart';

class ProductionLineAndGroupsCubit extends Cubit<ProductionLineAndGroupsState> {
  
  ProductionLineAndGroupsCubit({
    required ErrorRepository errorRepository,
    required ProductionLineRepository productionLineRepository
  }) : _productionLineRepository = productionLineRepository, _errorRepository = errorRepository, super(const ProductionLineAndGroupUnloaded());

    final ProductionLineRepository _productionLineRepository;
    final ErrorRepository _errorRepository;

    Future loadProductionLines() async {
      if (state.productionLineAndGroupsLoadState is ProductionLineAndGroupLoading) return;

      emit(const ProductionLineAndGroupLoading());

      try {
        var prdLinesAndGroups = await _productionLineRepository.getProductionLineAndGroupsList();
        emit(ProductionLineAndGroupLoaded(productionLineAndGroups: prdLinesAndGroups));
      } catch (e) {
        _errorRepository.communicateError(e);
        emit(const ProductionLineAndGroupUnloaded());
      }

    }

    void unselectTenant() => emit(const ProductionLineAndGroupUnloaded());

  @override
  Future<void> close() {
    return super.close();
  }

}
