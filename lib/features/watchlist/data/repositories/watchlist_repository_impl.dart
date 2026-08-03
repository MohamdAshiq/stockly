import '../../../home/data/datasources/local_stock_search_dataset.dart';
import '../../../home/data/datasources/stock_remote_data_source.dart';
import '../../../home/domain/entities/stock_entity.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_local_data_source.dart';
import '../models/stock_hive_model.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;
  final StockRemoteDataSource remoteDataSource;

  WatchlistRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<StockEntity>> getWatchlist() async {
    final hiveModels = await localDataSource.getSavedStocks();
    return hiveModels.map((model) {
      return StockEntity(
        symbol: model.symbol,
        name: model.name,
        price: model.price,
        isSaved: true,
        isPriceLoading: false,
      );
    }).toList();
  }

  @override
  Future<void> removeFromWatchlist(String symbol) async {
    await localDataSource.removeStock(symbol);
  }

  @override
  Future<List<StockEntity>> refreshWatchlistPrices() async {
    final savedModels = await localDataSource.getSavedStocks();
    final updatedEntities = <StockEntity>[];

    for (final model in savedModels) {
      double latestPrice = model.price;
      String changePercent = '0.00%';

      try {
        final quote = await remoteDataSource.getStockPrice(model.symbol);
        if (quote.price > 0) {
          latestPrice = quote.price;
          changePercent = quote.changePercent;
        }
      } catch (_) {
        final localMatches = LocalStockSearchDataset.search(model.symbol);
        if (localMatches.isNotEmpty && localMatches.first.price > 0) {
          latestPrice = localMatches.first.price;
          changePercent = localMatches.first.changePercent;
        }
      }

      // Update Hive model with new price
      final updatedHiveModel = StockHiveModel(
        symbol: model.symbol,
        name: model.name,
        price: latestPrice,
        savedAt: model.savedAt,
      );
      await localDataSource.saveStock(updatedHiveModel);

      updatedEntities.add(
        StockEntity(
          symbol: model.symbol,
          name: model.name,
          price: latestPrice,
          changePercent: changePercent,
          isSaved: true,
          isPriceLoading: false,
        ),
      );
    }
    return updatedEntities;
  }
}
