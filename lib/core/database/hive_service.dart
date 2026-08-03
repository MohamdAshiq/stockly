import 'package:hive_flutter/hive_flutter.dart';
import '../../features/watchlist/data/models/stock_hive_model.dart';
import '../errors/exceptions.dart';

class HiveService {
  static const String watchlistBoxName = 'watchlist_box';

  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      if (!Hive.isAdapterRegistered(StockHiveModelAdapter().typeId)) {
        Hive.registerAdapter(StockHiveModelAdapter());
      }
      await Hive.openBox<StockHiveModel>(watchlistBoxName);
    } catch (e) {
      throw CacheException('Failed to initialize Hive database: $e');
    }
  }

  Box<StockHiveModel> get watchlistBox {
    if (!Hive.isBoxOpen(watchlistBoxName)) {
      throw CacheException('Watchlist box is not open');
    }
    return Hive.box<StockHiveModel>(watchlistBoxName);
  }
}
