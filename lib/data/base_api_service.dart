import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:quadraclub_app/data/storage_service.dart';

import '../../app_exports.dart';
import '../../main.dart';
import '../di/locator.dart';
import 'app_config.dart';

enum HttpMethod { get, post, put, delete, patch }

class BaseApiProvider {
  late final Dio _dio;
  final _storage = locator.get<StorageService>();
  static const String keyToken = 'jwt_token';

  BaseApiProvider() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {"Content-Type": "application/json"},
      ),
    );

    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: false,
        maxWidth: 90,
        logPrint: (object) =>
            log(object.toString()), // ✅ override print with log()
      ),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final isAuthEndpoint = e.requestOptions.path.contains(
              '/auth/login',
            );

            if (!isAuthEndpoint) {
              // No refresh-token endpoint exists yet, so any 401 outside
              // of login means the session is genuinely invalid.
              await _handleSessionExpired();
            }
            // For login endpoint 401s, do nothing here — let it fall
            // through to handleDioError so AuthBloc shows the real message.
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  void _setAuthToken(String endpoint) {
    final token = _storage.getToken();
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<Response> request({
    required HttpMethod method,
    required String endpoint,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool isFormData = false,
  }) async {
    _setAuthToken(endpoint);
    try {
      final Map<String, dynamic> finalHeaders = {...?headers};
      if (isFormData) {
        finalHeaders['Content-Type'] = 'multipart/form-data';
      }

      final options = Options(headers: finalHeaders);

      switch (method) {
        case HttpMethod.get:
          return await _dio.get(
            endpoint,
            queryParameters: queryParameters,
            options: options,
          );
        case HttpMethod.post:
          return await _dio.post(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
        case HttpMethod.put:
          return await _dio.put(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
        case HttpMethod.delete:
          return await _dio.delete(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
        case HttpMethod.patch:
          return await _dio.patch(
            endpoint,
            data: data,
            queryParameters: queryParameters,
            options: options,
          );
      }
    } on DioException catch (e) {
      throw await handleDioError(e);
    } catch (e) {
      log("Unexpected error: ${e.toString()}");
      throw Exception("Unexpected error occurred: ${e.toString()}");
    }
  }

  Future<Exception> handleDioError(DioException error) async {
    log("Processing DioException: ${error.type}");

    if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      log("Full response data: $responseData");
      if (statusCode == 401) {
        if (responseData is String) {
          throw Exception(responseData);
        }
        if (responseData is Map) {
          final errorMessage =
              responseData['message'] ??
              responseData['error'] ??
              'Invalid credentials';
          throw Exception(errorMessage);
        }
        throw Exception('Invalid credentials');
      }

      // Handle other error responses
      String message = 'Something went wrong!';

      if (responseData is String) {
        message = responseData;
      } else if (responseData is Map) {
        String? extractFirst(dynamic field) {
          if (field is List && field.isNotEmpty) {
            return field.first.toString();
          }
          return null;
        }

        message =
            responseData['message'] ??
            responseData['error'] ??
            responseData['detail'] ??
            responseData['url'] ??
            extractFirst(responseData['non_field_errors']) ??
            extractFirst(
              responseData['nfc_tag_id'],
            ) ?? // ✅ your case handled here
            extractFirst(responseData['username']) ??
            extractFirst(responseData['email']) ??
            extractFirst(responseData['password']) ??
            'Something went wrong!';
      }

      log("Response: $responseData");
      log("Error $statusCode: $message");
      throw Exception(message);
    }

    final String errorMessage;
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timeout. Please try again later.";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Send timeout. Please check your internet.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Receive timeout. Please try again later.";
        break;
      case DioExceptionType.cancel:
        errorMessage = "Request was cancelled.";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "Connection error. Please check your internet.";
        break;
      case DioExceptionType.badCertificate:
        errorMessage = "Bad certificate. Please check your certificate.";
        break;
      case DioExceptionType.badResponse:
        errorMessage = "Bad response. Please try again later.";
        break;
      default:
        errorMessage = "An unexpected error occurred: ${error.message}";
    }

    throw Exception(errorMessage);
  }

  Future<bool> _refreshToken() async {
    final context = navigatorKey.currentContext!;
    final refreshToken = _storage.getRefreshToken();

    if (refreshToken != null) {
      try {
        final response = await Dio().post(
          '${AppConfig.baseUrl}/auth/refreshAccessToken',
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final newAccessToken = response.data['accessToken'];
          final newRefreshToken = response.data['refreshToken'];

          await Future.wait([
            _storage.saveToken(newAccessToken),
            _storage.saveRefreshToken(newRefreshToken),
          ]);

          _dio.options.headers['Authorization'] = 'Bearer $newAccessToken';
          return true;
        }
        _storage.clearAll();
        if (!context.mounted) return false;
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.signIn,
          (route) => false,
        );
        return false;
      } catch (e, stackTrace) {
        if (!context.mounted) return false;

        log('Token refresh error: $e', stackTrace: stackTrace);
        context.showToast('Session expired, please login again');
        _storage.clearAll();
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.signIn,
          (route) => false,
        );
        return false;
      }
    } else {
      if (!context.mounted) return false;

      context.showToast('Session expired, please login again');
      _storage.clearAll();
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.signIn,
        (route) => false,
      );
      return false;
    }
  }

  Future<void> _handleSessionExpired() async {
    final context = navigatorKey.currentContext!;

    await _storage.clearAll();

    if (!context.mounted) return;

    context.showToast('Session expired, please login again');
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteName.signIn,
      (route) => false,
    );
  }
}
