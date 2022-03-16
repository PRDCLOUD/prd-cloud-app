import 'package:equatable/equatable.dart';
import 'package:models/models.dart';
import 'package:models/src/utils/date_time_functions.dart';
import 'package:timezone/timezone.dart' as tz;

class ProductionItemOfList extends Equatable {

  final int id;
  final String? productionLine;
  final String? product;
  final DateTime? begin;
  final DateTime? end;
  final String? createdBy;
  final DateTime? createdDate;
  final String? updatedBy;
  final DateTime? updatedDate;

  final ProductionDataStatus status;

  ProductionItemOfList({
    required this.id, 
    required this.productionLine, 
    required this.product, 
    required this.begin, 
    required this.end, 
    required this.createdBy, 
    required this.createdDate, 
    required this.updatedBy, 
    required this.updatedDate,
    required this.status
  });

  factory ProductionItemOfList.fromJson(ProductionDataStatus status, Map<String, dynamic> json, tz.Location location) {
    return ProductionItemOfList(
      id: json['ID'],
      productionLine: json['ProductionLine'],
      product: json['Product'],
      begin: DateTimeFunctions.parseDateTime(json['Begin'] as String?, location),
      end: DateTimeFunctions.parseDateTime(json['End'] as String?, location),
      createdBy: json['CreatedBy'],
      createdDate: DateTimeFunctions.parseDateTime(json['Begin'] as String?, location),
      updatedBy: json['UpdatedBy'],
      updatedDate: DateTimeFunctions.parseDateTime(json['Begin'] as String?, location),
      status: status
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      productionLine,
      product,
      begin,
      end,
      createdBy,
      createdDate,
      updatedBy,
      updatedDate,
      status
    ];
  }

}
