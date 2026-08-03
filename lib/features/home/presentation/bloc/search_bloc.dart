import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/stock_entity.dart';
import '../../domain/repositories/stock_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final StockRepository repository;

  SearchBloc({required this.repository}) : super(SearchInitialState()) {
    on<SearchQueryChangedEvent>(
      _onSearchQueryChanged,
      transformer: debounce(const Duration(milliseconds: 600)),
    );
    on<ToggleSaveStockEvent>(_onToggleSaveStock);
  }

  Future<void> _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitialState());
      return;
    }

    emit(SearchLoadingState());

    try {
      final results = await repository.searchStocks(query);
      if (results.isEmpty) {
        emit(SearchEmptyState());
      } else {
        emit(SearchLoadedState(results));
        await _fetchPricesForLoadedStocks(results, emit);
      }
    } on RateLimitException catch (e) {
      emit(SearchErrorState(e.message));
    } on ServerException catch (e) {
      emit(SearchErrorState(e.message));
    } on NetworkException catch (e) {
      emit(SearchErrorState(e.message));
    } catch (e) {
      emit(SearchErrorState('Failed to search stocks: ${e.toString()}'));
    }
  }

  Future<void> _fetchPricesForLoadedStocks(
    List<StockEntity> initialResults,
    Emitter<SearchState> emit,
  ) async {
    final updatedList = List<StockEntity>.from(initialResults);

    // Fetch prices for top 3 matches
    final count = updatedList.length > 3 ? 3 : updatedList.length;

    for (int i = 0; i < count; i++) {
      if (emit.isDone) break;
      if (i > 0) {
        await Future.delayed(const Duration(milliseconds: 1200));
      }

      final stock = updatedList[i];
      try {
        final updatedStock = await repository.fetchStockPrice(stock);
        updatedList[i] = updatedStock;
        if (!emit.isDone) {
          emit(SearchLoadedState(List.from(updatedList)));
        }
      } catch (_) {
        updatedList[i] = stock.copyWith(isPriceLoading: false);
        if (!emit.isDone) {
          emit(SearchLoadedState(List.from(updatedList)));
        }
      }
    }

    // Mark all remaining items as not loading price
    if (!emit.isDone) {
      final finalizedList = updatedList
          .map((s) => s.copyWith(isPriceLoading: false))
          .toList();
      emit(SearchLoadedState(finalizedList));
    }
  }

  Future<void> _onToggleSaveStock(
    ToggleSaveStockEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state is SearchLoadedState) {
      final currentList = (state as SearchLoadedState).stocks;
      final target = event.stock;

      if (target.isSaved) {
        await repository.removeStockFromWatchlist(target.symbol);
      } else {
        await repository.saveStockToWatchlist(target);
      }

      final updatedList = currentList.map((s) {
        if (s.symbol == target.symbol) {
          return s.copyWith(isSaved: !s.isSaved);
        }
        return s;
      }).toList();

      emit(SearchLoadedState(updatedList));
    }
  }
}
