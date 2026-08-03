import '../../../../core/database/hive_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/stock_hive_model.dart';

abstract class WatchlistLocalDataSource {
  Future<List<StockHiveModel>> getSavedStocks();
  Future<void> saveStock(StockHiveModel stock);
  Future<void> removeStock(String symbol);
  bool isStockSaved(String symbol);
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final HiveService hiveService;

  WatchlistLocalDataSourceImpl({required this.hiveService});

  @override
  Future<List<StockHiveModel>> getSavedStocks() async {
    try {
      final box = hiveService.watchlistBox;
      return box.values.toList();
    } catch (e) {
      throw CacheException('Failed to fetch saved stocks from watchlist: $e');
    }
  }

  @override
  Future<void> saveStock(StockHiveModel stock) async {
    try {
      final box = hiveService.watchlistBox;
      await box.put(stock.symbol.toUpperCase(), stock);
    } catch (e) {
      throw CacheException('Failed to save stock to watchlist: $e');
    }
  }

  @override
  Future<void> removeStock(String symbol) async {
    try {
      final box = hiveService.watchlistBox;
      await box.delete(symbol.toUpperCase());
    } catch (e) {
      throw CacheException('Failed to remove stock from watchlist: $e');
    }
  }

  @override
  bool isStockSaved(String symbol) {
    try {
      final box = hiveService.watchlistBox;
      return box.containsKey(symbol.toUpperCase());
    } catch (e) {
      return false;
    }
  }
}
