import 'package:hive/hive.dart';
part 'stock_hive_model.g.dart';

@HiveType(typeId: 0)
class StockHiveModel extends HiveObject {
  @HiveField(0)
  final String symbol;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double price;
  @HiveField(3)
  final DateTime savedAt;

  StockHiveModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.savedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'price': price,
      'savedAt': savedAt.toIso8601String(),
    };
  }

  factory StockHiveModel.fromJson(Map<String, dynamic> json) {
    return StockHiveModel(
      symbol: json['symbol'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      savedAt: DateTime.parse(json['savedAt'] as String),
    );
  }
}
