import '../../domain/entities/stock_entity.dart';

class LocalStockSearchDataset {
  static const List<StockEntity> stocks = [
    StockEntity(
      symbol: 'TCS',
      name: 'Tata Consultancy Services Ltd',
      price: 3420.50,
      changePercent: '+1.25%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'TATAMOTORS',
      name: 'Tata Motors Limited',
      price: 950.30,
      changePercent: '+0.85%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'TATASTEEL',
      name: 'Tata Steel Limited',
      price: 155.80,
      changePercent: '-0.40%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'TATAPOWER',
      name: 'Tata Power Company Ltd',
      price: 425.10,
      changePercent: '+2.10%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'TATACHEM',
      name: 'Tata Chemicals Limited',
      price: 1080.00,
      changePercent: '+0.15%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'HDFCBANK',
      name: 'HDFC Bank Limited',
      price: 1640.00,
      changePercent: '+0.60%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'ICICIBANK',
      name: 'ICICI Bank Limited',
      price: 1120.00,
      changePercent: '+1.05%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'RELIANCE',
      name: 'Reliance Industries Ltd',
      price: 2980.00,
      changePercent: '-0.20%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'INFY',
      name: 'Infosys Limited',
      price: 1520.40,
      changePercent: '+0.75%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'WIPRO',
      name: 'Wipro Limited',
      price: 460.00,
      changePercent: '-0.10%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'ITC',
      name: 'ITC Limited',
      price: 465.20,
      changePercent: '+0.30%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'ASIANPAINT',
      name: 'Asian Paints Limited',
      price: 2950.00,
      changePercent: '+0.50%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'AAPL',
      name: 'Apple Inc',
      price: 220.50,
      changePercent: '+1.10%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'TSLA',
      name: 'Tesla Inc',
      price: 215.30,
      changePercent: '-2.15%',
      isPriceLoading: false,
    ),
    StockEntity(
      symbol: 'MSFT',
      name: 'Microsoft Corporation',
      price: 445.80,
      changePercent: '+0.45%',
      isPriceLoading: false,
    ),
  ];

  static List<StockEntity> search(String query) {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return [];

    return stocks.where((stock) {
      final symbolMatch = stock.symbol.toLowerCase().contains(cleanQuery);
      final nameMatch = stock.name.toLowerCase().contains(cleanQuery);
      return symbolMatch || nameMatch;
    }).toList();
  }
}
