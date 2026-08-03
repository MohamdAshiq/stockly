import '../../../watchlist/data/datasources/watchlist_local_data_source.dart';
import '../../../watchlist/data/models/stock_hive_model.dart';
import '../../domain/entities/stock_entity.dart';
import '../../domain/repositories/stock_repository.dart';
import '../datasources/local_stock_search_dataset.dart';
import '../datasources/stock_remote_data_source.dart';

class StockRepositoryImpl implements StockRepository {
  final StockRemoteDataSource remoteDataSource;
  final WatchlistLocalDataSource localDataSource;

  StockRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<StockEntity>> searchStocks(String query) async {
    try {
      final searchModels = await remoteDataSource.searchStocks(query);
      if (searchModels.isNotEmpty) {
        return searchModels.map((model) {
          final isSaved = localDataSource.isStockSaved(model.symbol);
          return model.toEntity(isSaved: isSaved);
        }).toList();
      }
    } catch (_) {}

    final fallbackResults = LocalStockSearchDataset.search(query);
    return fallbackResults.map((stock) {
      final isSaved = localDataSource.isStockSaved(stock.symbol);
      return stock.copyWith(isSaved: isSaved);
    }).toList();
  }

  @override
  Future<StockEntity> fetchStockPrice(StockEntity stock) async {
    try {
      final quote = await remoteDataSource.getStockPrice(stock.symbol);
      if (quote.price > 0) {
        return stock.copyWith(
          price: quote.price,
          changePercent: quote.changePercent,
          isPriceLoading: false,
        );
      }
    } catch (_) {}

    // Check if preset price exists in local dataset
    final localMatches = LocalStockSearchDataset.search(stock.symbol);
    if (localMatches.isNotEmpty && localMatches.first.price > 0) {
      final match = localMatches.first;
      return stock.copyWith(
        price: match.price,
        changePercent: match.changePercent,
        isPriceLoading: false,
      );
    }
    return stock.copyWith(isPriceLoading: false);
  }

  @override
  Future<void> saveStockToWatchlist(StockEntity stock) async {
    final hiveModel = StockHiveModel(
      symbol: stock.symbol,
      name: stock.name,
      price: stock.price,
      savedAt: DateTime.now(),
    );
    await localDataSource.saveStock(hiveModel);
  }

  @override
  Future<void> removeStockFromWatchlist(String symbol) async {
    await localDataSource.removeStock(symbol);
  }

  @override
  bool isStockSavedInWatchlist(String symbol) {
    return localDataSource.isStockSaved(symbol);
  }
}
