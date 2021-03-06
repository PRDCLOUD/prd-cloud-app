import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'dart:math';


class ProductionDataGroup extends Equatable {
  final List<ProductionData> productionDataGroup;

  ProductionDataGroup(this.productionDataGroup);

  @override
  List<Object?> get props => [productionDataGroup];  

  int getId() => productionDataGroup.map((e) => e.id).reduce(min);
  
  bool hasProductionData(int productionDataId) => productionDataGroup.any((x) => x.id == productionDataId);

  ProductionDataGroup copyWithBegin(DateTime? begin) {
    var updatedProductionData = productionDataGroup.map((e) => e.copyWith(begin: Optional.value(begin))).toList();
    return ProductionDataGroup(updatedProductionData);
  }

  ProductionDataGroup copyWithEnd(DateTime? end) {
    var updatedProductionData = productionDataGroup.map((e) => e.copyWith(end: Optional.value(end))).toList();
    return ProductionDataGroup(updatedProductionData);
  }

  ProductionDataGroup copyWithComments(String? comments) {
    var updatedProductionData = productionDataGroup.map((e) => e.copyWith(comments: Optional.value(comments))).toList();
    return ProductionDataGroup(updatedProductionData);
  }

  ProductionDataGroup copyWithProductionData(ProductionData productionData) {
    var changedProductionDataList = productionDataGroup.map((e) {
      if (e.id == productionData.id) {
        return productionData;
      } else {
        return e;
      }
    }).cast<ProductionData>().toList();

    return ProductionDataGroup(changedProductionDataList);
  }

  ProductionDataGroup copyWithProductId(int productionDataId, int? productId) {

    var changedProductionDataList = productionDataGroup.map((e) {
      if (e.id == productionDataId) {
        return e.copyWith(productId: Optional.value(productId));
      } else {
        return e;
      }
    }).cast<ProductionData>().toList();

    return ProductionDataGroup(changedProductionDataList);
  }

  List<ProductionVariable> getProductionVariables() => productionDataGroup.map((e) => e.lineUnits).expand((e) => e).map((e) => e.lineUnit.productionVariables).expand((e) => e).toList();

  List<ProductionLineUnit> getProductionLineUnits() => productionDataGroup.map((e) => e.lineUnits).expand((e) => e).toList();

  List<LineUnit> getLineUnits() => getProductionLineUnits().map((e) => e.lineUnit).toList();

  List<Loss> getProductionLossOptions() => productionDataGroup.map((e) => e.lossesOptions).expand((e) => e).toList();

  List<Stop> getProductionStopOptions() => productionDataGroup.map((e) => e.stopOptions).expand((e) => e).toList();

  List<ProductionLoss> getProductionLosses() => productionDataGroup.map((e) => e.losses).expand((e) => e).toList();

  List<ProductionStop> getProductionStops() => productionDataGroup.map((e) => e.stops).expand((e) => e).toList();
}
