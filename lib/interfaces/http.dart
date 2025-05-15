import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tokenai/utils/errors/errors.dart';

class Http {
  final String _baseUrl;
  late final BaseOptions? _options;
  late final Dio _dio;

  Http(this._baseUrl) {
    _buildBaseOptions();
    _buildHttpClient();
  }

  void _buildBaseOptions() {
    _options = BaseOptions(
      baseUrl: _baseUrl,
      receiveDataWhenStatusError: true,
      responseType: ResponseType.json,
    );
  }

  void _buildHttpClient() {
    _dio = Dio(_options);
  }

  Http addInterceptor(Interceptor interceptor) {
    _dio.interceptors.add(interceptor);

    return this;
  }

  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _requestHandler(() async {
      final token = "";
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            ...?headers,
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    });
  }

  Future<dynamic> post({
    required String url,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    return _requestHandler(() async {
      final token = "";
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            ...?headers,
            if (token != null) 'Authorization': 'Bearer $token',
          },
        ),
      );
      return response.data;
    });
  }

  Future<dynamic> patch({required String url, Map<String, dynamic>? data}) {
    return _requestHandler(() => _dio.patch(url, data: data));
  }

  Future<dynamic> put({required String url, Map<String, dynamic>? data}) {
    return _requestHandler(() => _dio.put(url, data: data));
  }

  Future<dynamic> delete({
    required String url,
    Map<String, dynamic>? queryParameters,
  }) {
    return _requestHandler(
      () => _dio.delete(url, queryParameters: queryParameters),
    );
  }

  Future<dynamic> _requestHandler(Future<dynamic> Function() request) async {
    try {
      return await request();
    } on DioError catch (error) {
      if (error.error is SocketException) {
        throw NoInternetConnectionException();
      }

      if (error.response?.statusCode != null) {
        final responseData = error.response?.data;
        String errorMessage = 'An error occurred';

        if (responseData is String) {
          try {
            final Map<String, dynamic> jsonData = jsonDecode(responseData);
            errorMessage = jsonData['description'] ?? errorMessage;
          } catch (e) {
            errorMessage = responseData;
          }
        } else if (responseData is Map) {
          errorMessage = responseData['description'] ?? errorMessage;
        }

        switch (error.response?.statusCode) {
          case 400:
            throw BadRequestException(errorMessage);
          case 401:
            throw UnauthorizedException(message: errorMessage);
          case 403:
            throw UnauthorizedException(message: errorMessage);
          case 404:
            throw NotFoundException(message: errorMessage);
          case 500:
            throw ServerException();
          default:
            throw ServerException();
        }
      }

      throw ServerException();
    }
  }
}
