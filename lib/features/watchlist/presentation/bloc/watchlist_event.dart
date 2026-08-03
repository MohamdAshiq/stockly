import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlistEvent extends WatchlistEvent {
  const LoadWatchlistEvent();
}

class RemoveFromWatchlistEvent extends WatchlistEvent {
  final String symbol;

  const RemoveFromWatchlistEvent(this.symbol);

  @override
  List<Object?> get props => [symbol];
}

class RefreshWatchlistEvent extends WatchlistEvent {
  const RefreshWatchlistEvent();
}
