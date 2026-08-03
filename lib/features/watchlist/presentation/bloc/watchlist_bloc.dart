import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/watchlist_repository.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final WatchlistRepository repository;

  WatchlistBloc({required this.repository})
    : super(const WatchlistInitialState()) {
    on<LoadWatchlistEvent>(_onLoadWatchlist);
    on<RemoveFromWatchlistEvent>(_onRemoveFromWatchlist);
    on<RefreshWatchlistEvent>(_onRefreshWatchlist);
  }

  Future<void> _onLoadWatchlist(
    LoadWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(const WatchlistLoadingState());
    try {
      final stocks = await repository.getWatchlist();
      if (stocks.isEmpty) {
        emit(const WatchlistEmptyState());
      } else {
        emit(WatchlistLoadedState(stocks));
      }
    } catch (e) {
      emit(WatchlistErrorState('Failed to load watchlist: ${e.toString()}'));
    }
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      await repository.removeFromWatchlist(event.symbol);

      if (state is WatchlistLoadedState) {
        final currentList = (state as WatchlistLoadedState).stocks;
        final updatedList = currentList
            .where((s) => s.symbol != event.symbol)
            .toList();

        if (updatedList.isEmpty) {
          emit(const WatchlistEmptyState());
        } else {
          emit(WatchlistLoadedState(updatedList));
        }
      } else {
        add(const LoadWatchlistEvent());
      }
    } catch (e) {
      emit(WatchlistErrorState('Failed to remove stock: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshWatchlist(
    RefreshWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    try {
      final updatedStocks = await repository.refreshWatchlistPrices();
      if (updatedStocks.isEmpty) {
        emit(const WatchlistEmptyState());
      } else {
        emit(WatchlistLoadedState(updatedStocks));
      }
    } catch (e) {
      //
    }
  }
}
