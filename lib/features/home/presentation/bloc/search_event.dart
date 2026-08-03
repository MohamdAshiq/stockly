import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_entity.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;

  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleSaveStockEvent extends SearchEvent {
  final StockEntity stock;

  const ToggleSaveStockEvent(this.stock);

  @override
  List<Object?> get props => [stock];
}
