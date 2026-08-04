import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/stock_entity.dart';
import 'stock_detail_state.dart';

class StockDetailCubit extends Cubit<StockDetailState> {
  final VoidCallback? onToggleSaveCallback;

  StockDetailCubit({required StockEntity stock, this.onToggleSaveCallback})
    : super(
        StockDetailState(
          stock: stock,
          isSaved: stock.isSaved,
          chartPrices: _generateChartPrices(
            stock.price,
            stock.changePercent,
            stock.symbol,
          ),
        ),
      );

  static List<double> _generateChartPrices(
    double basePrice,
    String changePercentStr,
    String symbol,
  ) {
    if (basePrice <= 0) basePrice = 150.0;
    final isNegative = changePercentStr.contains('-');
    final random = Random(symbol.hashCode);

    final List<double> result = [];
    double current = isNegative ? basePrice * 1.05 : basePrice * 0.95;

    for (int i = 0; i < 20; i++) {
      result.add(current);
      final variance = (random.nextDouble() - 0.48) * (basePrice * 0.02);
      current += variance;
    }
    result.add(basePrice);
    return result;
  }

  void toggleSave() {
    final updatedSaved = !state.isSaved;
    final updatedStock = state.stock.copyWith(isSaved: updatedSaved);
    emit(state.copyWith(isSaved: updatedSaved, stock: updatedStock));

    if (onToggleSaveCallback != null) {
      onToggleSaveCallback!();
    }
  }
}
