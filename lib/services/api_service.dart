import 'dart:convert';

import 'package:fang/config/environment.dart';
import 'package:fang/storage/auth_storage.dart';
import 'package:fang/utils/api_logger.dart';
import 'package:http/http.dart' as http;

/// Base API service class that provides reusable HTTP methods
/// All service classes should extend this class to make API calls
class ApiService {
  /// Gets the base API URL from the current environment configuration
  String get baseUrl => EnvironmentConfig.apiUrl;

  /// Gets the default headers for API requests
  Future<Map<String, String>> _getHeaders({
    Map<String, String>? additionalHeaders,
    bool includeAuth = true,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      ...?additionalHeaders,
    };

    if (includeAuth) {
      final token = await AuthStorage.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// Performs a GET request
  ///
  /// [endpoint] - The API endpoint (e.g., '/profile' or '/profile/123')
  /// [headers] - Additional headers to include in the request
  /// [includeAuth] - Whether to include authentication token (default: true)
  Future<http.Response> getRequest(
    String endpoint, {
    Map<String, String>? headers,
    bool includeAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getHeaders(
      additionalHeaders: headers,
      includeAuth: includeAuth,
    );

    final fullUrl = uri.toString();
    ApiLogger.logRequest(
      method: 'GET',
      endpoint: fullUrl,
      headers: requestHeaders,
    );

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.get(uri, headers: requestHeaders);
      stopwatch.stop();

      ApiLogger.logResponse(
        method: 'GET',
        endpoint: fullUrl,
        response: response,
        duration: stopwatch.elapsed,
      );

      return response;
    } catch (e, stackTrace) {
      stopwatch.stop();
      ApiLogger.logError(
        method: 'GET',
        endpoint: fullUrl,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs a POST request
  ///
  /// [endpoint] - The API endpoint (e.g., '/profile')
  /// [body] - The request body (can be Map, String, or any object with toJson())
  /// [headers] - Additional headers to include in the request
  /// [includeAuth] - Whether to include authentication token (default: true)
  Future<http.Response> postRequest(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    bool includeAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getHeaders(
      additionalHeaders: headers,
      includeAuth: includeAuth,
    );

    String? bodyString;
    dynamic bodyToLog;
    if (body != null) {
      if (body is String) {
        bodyString = body;
        bodyToLog = body;
      } else if (body is Map || body is List) {
        bodyString = jsonEncode(body);
        bodyToLog = body;
      } else {
        // Assume it has a toJson method
        bodyToLog = body;
        bodyString = jsonEncode(body);
      }
    }

    final fullUrl = uri.toString();
    ApiLogger.logRequest(
      method: 'POST',
      endpoint: fullUrl,
      headers: requestHeaders,
      body: bodyToLog,
    );

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.post(
        uri,
        headers: requestHeaders,
        body: bodyString,
      );
      stopwatch.stop();

      ApiLogger.logResponse(
        method: 'POST',
        endpoint: fullUrl,
        response: response,
        duration: stopwatch.elapsed,
      );

      return response;
    } catch (e, stackTrace) {
      stopwatch.stop();
      ApiLogger.logError(
        method: 'POST',
        endpoint: fullUrl,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs a PUT request
  ///
  /// [endpoint] - The API endpoint (e.g., '/profile/123')
  /// [body] - The request body (can be Map, String, or any object with toJson())
  /// [headers] - Additional headers to include in the request
  /// [includeAuth] - Whether to include authentication token (default: true)
  Future<http.Response> putRequest(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    bool includeAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getHeaders(
      additionalHeaders: headers,
      includeAuth: includeAuth,
    );

    String? bodyString;
    dynamic bodyToLog;
    if (body != null) {
      if (body is String) {
        bodyString = body;
        bodyToLog = body;
      } else if (body is Map || body is List) {
        bodyString = jsonEncode(body);
        bodyToLog = body;
      } else {
        // Assume it has a toJson method
        bodyToLog = body;
        bodyString = jsonEncode(body);
      }
    }

    final fullUrl = uri.toString();
    ApiLogger.logRequest(
      method: 'PUT',
      endpoint: fullUrl,
      headers: requestHeaders,
      body: bodyToLog,
    );

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.put(
        uri,
        headers: requestHeaders,
        body: bodyString,
      );
      stopwatch.stop();

      ApiLogger.logResponse(
        method: 'PUT',
        endpoint: fullUrl,
        response: response,
        duration: stopwatch.elapsed,
      );

      return response;
    } catch (e, stackTrace) {
      stopwatch.stop();
      ApiLogger.logError(
        method: 'PUT',
        endpoint: fullUrl,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs a PATCH request
  ///
  /// [endpoint] - The API endpoint (e.g., '/profile/123')
  /// [body] - The request body (can be Map, String, or any object with toJson())
  /// [headers] - Additional headers to include in the request
  /// [includeAuth] - Whether to include authentication token (default: true)
  Future<http.Response> patchRequest(
    String endpoint, {
    dynamic body,
    Map<String, String>? headers,
    bool includeAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getHeaders(
      additionalHeaders: headers,
      includeAuth: includeAuth,
    );

    String? bodyString;
    dynamic bodyToLog;
    if (body != null) {
      if (body is String) {
        bodyString = body;
        bodyToLog = body;
      } else if (body is Map || body is List) {
        bodyString = jsonEncode(body);
        bodyToLog = body;
      } else {
        // Assume it has a toJson method
        bodyToLog = body;
        bodyString = jsonEncode(body);
      }
    }

    final fullUrl = uri.toString();
    ApiLogger.logRequest(
      method: 'PATCH',
      endpoint: fullUrl,
      headers: requestHeaders,
      body: bodyToLog,
    );

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.patch(
        uri,
        headers: requestHeaders,
        body: bodyString,
      );
      stopwatch.stop();

      ApiLogger.logResponse(
        method: 'PATCH',
        endpoint: fullUrl,
        response: response,
        duration: stopwatch.elapsed,
      );

      return response;
    } catch (e, stackTrace) {
      stopwatch.stop();
      ApiLogger.logError(
        method: 'PATCH',
        endpoint: fullUrl,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Performs a DELETE request
  ///
  /// [endpoint] - The API endpoint (e.g., '/profile/123')
  /// [headers] - Additional headers to include in the request
  /// [includeAuth] - Whether to include authentication token (default: true)
  Future<http.Response> deleteRequest(
    String endpoint, {
    Map<String, String>? headers,
    bool includeAuth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    final requestHeaders = await _getHeaders(
      additionalHeaders: headers,
      includeAuth: includeAuth,
    );

    final fullUrl = uri.toString();
    ApiLogger.logRequest(
      method: 'DELETE',
      endpoint: fullUrl,
      headers: requestHeaders,
    );

    final stopwatch = Stopwatch()..start();
    try {
      final response = await http.delete(uri, headers: requestHeaders);
      stopwatch.stop();

      ApiLogger.logResponse(
        method: 'DELETE',
        endpoint: fullUrl,
        response: response,
        duration: stopwatch.elapsed,
      );

      return response;
    } catch (e, stackTrace) {
      stopwatch.stop();
      ApiLogger.logError(
        method: 'DELETE',
        endpoint: fullUrl,
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
