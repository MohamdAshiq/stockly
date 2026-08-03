import '../../../home/domain/entities/stock_entity.dart';

abstract class WatchlistRepository {
  Future<List<StockEntity>> getWatchlist();
  Future<void> removeFromWatchlist(String symbol);
  Future<List<StockEntity>> refreshWatchlistPrices();
}
