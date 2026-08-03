class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server Error']);
}

class RateLimitException implements Exception {
  final String message;
  RateLimitException([this.message = 'API Rate limit exceeded']);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No Internet Connection']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Database Error']);
}
