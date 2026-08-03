import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({Dio? dio}) {
    _dio =
        dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            responseType: ResponseType.json,
          ),
        );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters['apikey'] = ApiConstants.apiKey;
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.data is Map<String, dynamic>) {
            final data = response.data as Map<String, dynamic>;
            if (data.containsKey('Note') || data.containsKey('Information')) {
              debugPrint(
                'Alpha Vantage Rate Limit Hit: ${data['Note'] ?? data['Information']}',
              );
              throw RateLimitException(
                data['Note']?.toString() ??
                    data['Information']?.toString() ??
                    'API rate limit reached',
              );
            }
          }
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          debugPrint('Dio Error: ${error.message}');
          return handler.next(error);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> get(Map<String, dynamic> queryParameters) async {
    try {
      final response = await _dio.get('', queryParameters: queryParameters);

      if (response.data is Map<String, dynamic>) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ServerException('Invalid API response format');
      }
    } on RateLimitException {
      rethrow;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException('Network connection failed');
      }
      throw ServerException(e.message ?? 'Server error occurred');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
