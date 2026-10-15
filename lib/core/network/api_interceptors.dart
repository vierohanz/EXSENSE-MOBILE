import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService;
  final VoidCallback? onUnauthorized;

  AuthInterceptor({
    required StorageService storageService,
    this.onUnauthorized,
  }) : _storageService = storageService;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storageService.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _storageService.removeToken();
      onUnauthorized?.call();
    }
    return handler.next(err);
  }
}
