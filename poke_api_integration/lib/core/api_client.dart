import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({required this.dio});

  final Dio dio;

  Future<T> get<T>(
    String path, {
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
      );
      return fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<T> getByUrl<T>(
    String url, {
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final response = await dio.getUri<Map<String, dynamic>>(Uri.parse(url));
      return fromJson(response.data!);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

class ApiException implements Exception {
  ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  factory ApiException.fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Connection timed out');
      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection');
      case DioExceptionType.badResponse:
        return ApiException(
          message: e.response?.statusMessage ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled');
      default:
        return ApiException(message: e.message ?? 'Unexpected error');
    }
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
