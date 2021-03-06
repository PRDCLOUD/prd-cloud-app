import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:models/src/utils/date_time_functions.dart';
import 'package:timezone/timezone.dart' as tz;

enum ProductionDataStatus { 
  concluded, 
  opened, 
  canceled 
}

class ProductionData extends Equatable {

  final int id;

  final DateTime? begin;
  final DateTime? end;

  final int? productId;

  final int? productionLineId;

  final List<ProductionLineUnit> lineUnits;

  final List<ProductionLoss> losses; 
  final List<ProductionStop> stops;

  final List<Loss> lossesOptions;
  final List<Stop> stopOptions;

  final String? comments;

  final ProductionDataStatus status;

  final Map<int, LineUnit> lineUnitDict;

  List<Product> get products {
    return lineUnits.firstWhere((element) => element.type == 'ProductionLine').lineUnit.products ?? new List.empty();
  }

  ProductionData({
    required this.id, 
    required this.begin, 
    required this.end, 
    required this.productId, 
    required this.productionLineId, 
    required this.comments, 
    required this.status, 
    required this.stopOptions, 
    required this.stops,
    required this.lossesOptions, 
    required this.losses,
    required this.lineUnits,
    required this.lineUnitDict
  });


  factory ProductionData.fromJson(Map<String, dynamic> json, tz.Location location) {

    var stops = json['stops'].map((x) => ProductionStop.fromJson(x, location)).cast<ProductionStop>().toList() as List<ProductionStop>;
    stops.sort(((a, b) => a.codeName.toLowerCase().compareTo(b.codeName.toLowerCase())));

    var losssesOptions = json['lossesOptions'].map((x) => Loss.fromJson(x)).cast<Loss>().toList() as List<Loss>;
    losssesOptions.sort(((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())));

    var stopOptions = json['stopsOptions'].map((x) => Stop.fromJson(x)).cast<Stop>().toList() as List<Stop>;
    stopOptions.sort(((a, b) => a.codeName.toLowerCase().compareTo(b.codeName.toLowerCase())));

    var losses = json['losses'].map((x) => ProductionLoss.fromJson(x)).cast<ProductionLoss>().toList() as List<ProductionLoss>;
    losses.sort(((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())));

    var lineUnits = json['lineUnits'].map((x) => ProductionLineUnit.fromJson(x, location)).cast<ProductionLineUnit>().toList() as List<ProductionLineUnit>;
    lineUnits.sort((a, b) => a.order - b.order);

    var lineUnitDict = Map<int, LineUnit>.fromIterable(lineUnits, key: (x) => x.lineUnit.id, value: (x) => x.lineUnit); 

    return ProductionData(
      begin: DateTimeFunctions.parseDateTime(json['begin'] as String?, location),
      end: DateTimeFunctions.parseDateTime(json['end'] as String?, location),
      comments: json['comments'],
      productId: json['productId'],
      id: json['id'],
      productionLineId: json['productionLineId'],
      status: ProductionData._parseProductionDataStatus(json['status']),
      stopOptions: stopOptions,
      stops: stops,
      lossesOptions: losssesOptions,
      losses: losses,
      lineUnits: lineUnits,
      lineUnitDict: lineUnitDict,
    );
  }

  ProductionData copyWith({
    Optional<DateTime> begin = const Optional(),
    Optional<DateTime> end = const Optional(),
    Optional<int> productId = const Optional(),
    Optional<int> productionLineId = const Optional(),
    List<ProductionLineUnit>? lineUnits,
    List<ProductionLoss>? losses,
    List<ProductionStop>? stops,
    List<Loss>? lossesOptions,
    List<Stop>? stopOptions,
    Optional<String> comments = const Optional(),
    ProductionDataStatus? status,
    Map<int, LineUnit>? lineUnitDict
  }) {
    return ProductionData(
      id: id,
      begin: begin.valueOr(this.begin),
      end: end.valueOr(this.end),
      productId: productId.valueOr(this.productId),
      productionLineId: productionLineId.isValid ? productionLineId.value : this.productionLineId,
      lineUnits: lineUnits ?? this.lineUnits,
      losses: losses ?? this.losses,
      stops: stops ?? this.stops,
      lossesOptions: lossesOptions ?? this.lossesOptions,
      stopOptions: stopOptions ?? this.stopOptions,
      comments: comments.valueOr(this.comments),
      status: status ?? this.status,
      lineUnitDict: lineUnitDict ?? this.lineUnitDict
    );
  }

  static ProductionDataStatus _parseProductionDataStatus(int status) {
    switch(status) {
      case 0: return ProductionDataStatus.canceled;
      case 1: return ProductionDataStatus.opened;
      case 2: return ProductionDataStatus.concluded;
      default: throw Exception('Invalid Production Status');
    }
  }

  @override
  List<Object?> get props {
    return [
      id,
      begin,
      end,
      productId,
      productionLineId,
      lineUnits,
      losses,
      stops,
      lossesOptions,
      stopOptions,
      comments,
      status,
      lineUnitDict,
    ];
  }
}

extension ProductionBasicDataExtensions on ProductionData {
  Product? getSelectedProduct() {
    if (productId == null) {
      return null;
    } else {
      return products.firstWhere((e) => e.id == productId);
    }
  }

  ProductionLineUnit getProductionLine() {
    return lineUnits.firstWhere((e) => e.type == 'ProductionLine');
  }

}
