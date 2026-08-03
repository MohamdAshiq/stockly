import 'package:equatable/equatable.dart';

class StockEntity extends Equatable {
  final String symbol;
  final String name;
  final String type;
  final String region;
  final double price;
  final String changePercent;
  final bool isSaved;
  final bool isPriceLoading;

  const StockEntity({
    required this.symbol,
    required this.name,
    this.type = '',
    this.region = '',
    this.price = 0.0,
    this.changePercent = '0.00%',
    this.isSaved = false,
    this.isPriceLoading = true,
  });

  StockEntity copyWith({
    String? symbol,
    String? name,
    String? type,
    String? region,
    double? price,
    String? changePercent,
    bool? isSaved,
    bool? isPriceLoading,
  }) {
    return StockEntity(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      type: type ?? this.type,
      region: region ?? this.region,
      price: price ?? this.price,
      changePercent: changePercent ?? this.changePercent,
      isSaved: isSaved ?? this.isSaved,
      isPriceLoading: isPriceLoading ?? this.isPriceLoading,
    );
  }

  @override
  List<Object?> get props => [
    symbol,
    name,
    type,
    region,
    price,
    changePercent,
    isSaved,
    isPriceLoading,
  ];
}
