import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class ProductionDataFilter extends Equatable {

  // If filter key changes, the listener knows it needs a refresh
  final String filterKey;

  final ProductionDataStatus status;
  final int take;
  final List<String> prdLines;

  ProductionDataFilter({required this.filterKey, required this.status, required this.take, required this.prdLines});

  @override
  List<Object?> get props => [filterKey, status, take, prdLines];

  ProductionDataFilter copyWith({
    String? filterKey,
    ProductionDataStatus? status,
    int? take,
    List<String>? prdLines,
  }) {
    return ProductionDataFilter(
      filterKey : filterKey ?? this.filterKey,
      status: status ?? this.status,
      take: take ?? this.take,
      prdLines: prdLines ?? this.prdLines,
    );
  }
}
