import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../models/stock_quote_model.dart';
import '../models/stock_search_result_model.dart';

abstract class StockRemoteDataSource {
  Future<List<StockSearchResultModel>> searchStocks(String query);
  Future<StockQuoteModel> getStockPrice(String symbol);
}

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  final ApiClient apiClient;

  StockRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<StockSearchResultModel>> searchStocks(String query) async {
    final response = await apiClient.get({
      'function': ApiConstants.symbolSearchFunction,
      'keywords': query,
    });

    if (response.containsKey('bestMatches')) {
      final matchesList = response['bestMatches'] as List<dynamic>;
      return matchesList.map((json) {
        return StockSearchResultModel.fromJson(json as Map<String, dynamic>);
      }).toList();
    } else {
      throw ServerException('Invalid search response from server');
    }
  }

  @override
  Future<StockQuoteModel> getStockPrice(String symbol) async {
    final response = await apiClient.get({
      'function': ApiConstants.globalQuoteFunction,
      'symbol': symbol,
    });
    return StockQuoteModel.fromJson(response);
  }
}
