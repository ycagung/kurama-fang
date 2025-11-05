enum Environment { dev, staging, production }

/// Environment configuration for managing API URLs across different environments.
///
/// Usage:
/// ```dart
/// // Set the environment (typically in main.dart before runApp)
/// EnvironmentConfig.setEnvironment(Environment.dev);
///
/// // Or set it based on a build configuration
/// EnvironmentConfig.setEnvironment(Environment.production);
/// ```
class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.dev;

  static Environment get currentEnvironment => _currentEnvironment;

  /// Sets the current environment. Call this before making any API calls,
  /// typically in your main() function or app initialization.
  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }

  static String get apiUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return _devApiUrl;
      case Environment.staging:
        return _stagingApiUrl;
      case Environment.production:
        return _productionApiUrl;
    }
  }

  static String get socketUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return _devSocketUrl;
      case Environment.staging:
        return _stagingSocketUrl;
      case Environment.production:
        return _productionSocketUrl;
    }
  }

  // TODO: Replace these URLs with your actual API URLs
  static const String _devApiUrl = 'http://10.0.2.2:5000';
  static const String _stagingApiUrl = 'https://api-staging.example.com';
  static const String _productionApiUrl = 'https://api.example.com';

  // TODO: Replace these URLs with your actual Socket.io server URLs
  static const String _devSocketUrl = 'http://10.0.2.2:5050';
  static const String _stagingSocketUrl = 'https://socket-staging.example.com';
  static const String _productionSocketUrl = 'https://socket.example.com';
}
