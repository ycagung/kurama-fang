import 'dart:convert';
import 'package:http/http.dart' as http;

/// API Logger for logging all HTTP requests and responses
class ApiLogger {
  static const bool _enabled = true; // Set to false to disable logging
  static const bool _logHeaders = true;
  static const bool _logBody = true;

  /// Log an HTTP request
  static void logRequest({
    required String method,
    required String endpoint,
    required Map<String, String> headers,
    dynamic body,
  }) {
    if (!_enabled) return;

    print('\n${'=' * 80}');
    print('📤 API REQUEST');
    print('${'=' * 80}');
    print('Method: $method');
    print('Endpoint: $endpoint');
    
    if (_logHeaders) {
      print('Headers:');
      headers.forEach((key, value) {
        // Mask sensitive headers
        if (key.toLowerCase() == 'authorization') {
          final masked = value.length > 20 
              ? '${value.substring(0, 20)}...'
              : '***';
          print('  $key: $masked');
        } else {
          print('  $key: $value');
        }
      });
    }

    if (_logBody && body != null) {
      print('Body:');
      try {
        if (body is String) {
          // Try to format as JSON if possible
          try {
            final json = jsonDecode(body);
            print(JsonEncoder.withIndent('  ').convert(json));
          } catch (_) {
            print('  $body');
          }
        } else if (body is Map || body is List) {
          print(JsonEncoder.withIndent('  ').convert(body));
        } else {
          print('  $body');
        }
      } catch (e) {
        print('  [Error formatting body: $e]');
        print('  $body');
      }
    } else if (body != null) {
      print('Body: [Present but not logged]');
    }

    print('${'=' * 80}\n');
  }

  /// Log an HTTP response
  static void logResponse({
    required String method,
    required String endpoint,
    required http.Response response,
    Duration? duration,
  }) {
    if (!_enabled) return;

    print('\n${'=' * 80}');
    print('📥 API RESPONSE');
    print('${'=' * 80}');
    print('Method: $method');
    print('Endpoint: $endpoint');
    print('Status Code: ${response.statusCode}');
    print('Status: ${_getStatusText(response.statusCode)}');
    
    if (duration != null) {
      print('Duration: ${duration.inMilliseconds}ms');
    }

    if (_logHeaders) {
      print('Response Headers:');
      response.headers.forEach((key, value) {
        print('  $key: $value');
      });
    }

    if (_logBody) {
      print('Response Body:');
      try {
        if (response.body.isEmpty) {
          print('  [Empty response body]');
        } else {
          // Try to format as JSON if possible
          try {
            final json = jsonDecode(response.body);
            print(JsonEncoder.withIndent('  ').convert(json));
          } catch (_) {
            // Not JSON, print as plain text (truncated if too long)
            final body = response.body;
            if (body.length > 500) {
              print('  ${body.substring(0, 500)}... [truncated]');
            } else {
              print('  $body');
            }
          }
        }
      } catch (e) {
        print('  [Error formatting response: $e]');
        if (response.body.length > 500) {
          print('  ${response.body.substring(0, 500)}... [truncated]');
        } else {
          print('  ${response.body}');
        }
      }
    }

    print('${'=' * 80}\n');
  }

  /// Log an error
  static void logError({
    required String method,
    required String endpoint,
    required Object error,
    StackTrace? stackTrace,
  }) {
    if (!_enabled) return;

    print('\n${'=' * 80}');
    print('❌ API ERROR');
    print('${'=' * 80}');
    print('Method: $method');
    print('Endpoint: $endpoint');
    print('Error: $error');
    if (stackTrace != null) {
      print('Stack Trace:');
      print(stackTrace);
    }
    print('${'=' * 80}\n');
  }

  static String _getStatusText(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) return '✅ Success';
    if (statusCode >= 300 && statusCode < 400) return '🔄 Redirect';
    if (statusCode >= 400 && statusCode < 500) return '⚠️ Client Error';
    if (statusCode >= 500) return '❌ Server Error';
    return '❓ Unknown';
  }
}

