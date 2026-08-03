import '../entities/stock_entity.dart';

abstract class StockRepository {
  Future<List<StockEntity>> searchStocks(String query);
  Future<StockEntity> fetchStockPrice(StockEntity stock);
  Future<void> saveStockToWatchlist(StockEntity stock);
  Future<void> removeStockFromWatchlist(String symbol);
  bool isStockSavedInWatchlist(String symbol);
}
