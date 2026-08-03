import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {}

class SearchLoadingState extends SearchState {}

class SearchLoadedState extends SearchState {
  final List<StockEntity> stocks;

  const SearchLoadedState(this.stocks);

  @override
  List<Object?> get props => [stocks];
}

class SearchEmptyState extends SearchState {}

class SearchErrorState extends SearchState {
  final String message;

  const SearchErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
