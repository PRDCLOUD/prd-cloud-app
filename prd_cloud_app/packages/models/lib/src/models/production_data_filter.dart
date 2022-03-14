import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class ProductionDataFilter extends Equatable {

  final ProductionDataStatus status;
  final int take;
  final List<String> prdLines;

  ProductionDataFilter({required this.status, required this.take, required this.prdLines});

  @override
  List<Object?> get props => [status, take, prdLines];

  ProductionDataFilter copyWith({
    ProductionDataStatus? status,
    int? take,
    List<String>? prdLines,
  }) {
    return ProductionDataFilter(
      status: status ?? this.status,
      take: take ?? this.take,
      prdLines: prdLines ?? this.prdLines,
    );
  }
}
