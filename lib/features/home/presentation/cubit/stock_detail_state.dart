import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_entity.dart';

class StockDetailState extends Equatable {
  final StockEntity stock;
  final bool isSaved;
  final List<double> chartPrices;

  const StockDetailState({
    required this.stock,
    required this.isSaved,
    required this.chartPrices,
  });

  StockDetailState copyWith({
    StockEntity? stock,
    bool? isSaved,
    List<double>? chartPrices,
  }) {
    return StockDetailState(
      stock: stock ?? this.stock,
      isSaved: isSaved ?? this.isSaved,
      chartPrices: chartPrices ?? this.chartPrices,
    );
  }

  @override
  List<Object?> get props => [stock, isSaved, chartPrices];
}
