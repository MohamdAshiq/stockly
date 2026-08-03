import 'package:equatable/equatable.dart';
import '../../../home/domain/entities/stock_entity.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitialState extends WatchlistState {
  const WatchlistInitialState();
}

class WatchlistLoadingState extends WatchlistState {
  const WatchlistLoadingState();
}

class WatchlistLoadedState extends WatchlistState {
  final List<StockEntity> stocks;

  const WatchlistLoadedState(this.stocks);

  @override
  List<Object?> get props => [stocks];
}

class WatchlistEmptyState extends WatchlistState {
  const WatchlistEmptyState();
}

class WatchlistErrorState extends WatchlistState {
  final String message;

  const WatchlistErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
