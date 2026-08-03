import '../../domain/entities/stock_entity.dart';

class StockSearchResultModel {
  final String symbol;
  final String name;
  final String type;
  final String region;

  StockSearchResultModel({
    required this.symbol,
    required this.name,
    required this.type,
    required this.region,
  });

  factory StockSearchResultModel.fromJson(Map<String, dynamic> json) {
    return StockSearchResultModel(
      symbol: json['1. symbol'] as String? ?? '',
      name: json['2. name'] as String? ?? '',
      type: json['3. type'] as String? ?? '',
      region: json['4. region'] as String? ?? '',
    );
  }

  StockEntity toEntity({
    double price = 0.0,
    String changePercent = '0.00%',
    bool isSaved = false,
  }) {
    return StockEntity(
      symbol: symbol,
      name: name,
      type: type,
      region: region,
      price: price,
      changePercent: changePercent,
      isSaved: isSaved,
    );
  }
}
