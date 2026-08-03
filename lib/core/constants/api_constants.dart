import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static const String baseUrl = 'https://www.alphavantage.co/query';

  static String get apiKey => dotenv.env['ALPHA_VANTAGE_API_KEY'] ?? '';

  // API Functions
  static const String symbolSearchFunction = 'SYMBOL_SEARCH';
  static const String globalQuoteFunction = 'GLOBAL_QUOTE';
}
