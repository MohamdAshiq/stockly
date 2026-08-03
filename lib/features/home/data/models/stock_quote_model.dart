class StockQuoteModel {
  final String symbol;
  final double price;
  final String changePercent;

  StockQuoteModel({
    required this.symbol,
    required this.price,
    required this.changePercent,
  });

  factory StockQuoteModel.fromJson(Map<String, dynamic> json) {
    final quote = json['Global Quote'] as Map<String, dynamic>? ?? {};
    final priceStr = quote['05. price'] as String? ?? '0.0';
    final changeStr = quote['10. change percent'] as String? ?? '0.00%';

    return StockQuoteModel(
      symbol: quote['01. symbol'] as String? ?? '',
      price: double.tryParse(priceStr) ?? 0.0,
      changePercent: changeStr,
    );
  }
}
