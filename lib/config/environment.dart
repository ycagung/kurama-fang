import 'dart:io';

enum Environment { dev, staging, production }

/// Manages environment-specific configuration for API and socket URLs.
/// Works automatically across Android emulator, iOS simulator, and real devices.
class EnvironmentConfig {
  static Environment _currentEnvironment = Environment.dev;

  static Environment get currentEnvironment => _currentEnvironment;

  /// Call this before making API requests — typically in `main()`.
  static void setEnvironment(Environment env) {
    _currentEnvironment = env;
  }

  /// Returns the correct API base URL depending on the environment and platform.
  static String get apiUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return _getDevApiUrl();
      case Environment.staging:
        return _stagingApiUrl;
      case Environment.production:
        return _productionApiUrl;
    }
  }

  /// Returns the correct Socket base URL depending on the environment and platform.
  static String get socketUrl {
    switch (_currentEnvironment) {
      case Environment.dev:
        return _getDevSocketUrl();
      case Environment.staging:
        return _stagingSocketUrl;
      case Environment.production:
        return _productionSocketUrl;
    }
  }

  // ========== Private Helpers ==========

  static String _getDevApiUrl() {
    if (Platform.isAndroid) return 'http://10.0.2.2:5000'; // Android emulator
    if (Platform.isIOS) return 'http://localhost:5000'; // iOS simulator
    // For web or physical devices on same Wi-Fi:
    return 'http://192.168.1.8:5000'; // replace with your local IP
  }

  static String _getDevSocketUrl() {
    if (Platform.isAndroid) return 'http://10.0.2.2:5050';
    if (Platform.isIOS) return 'http://localhost:5050';
    return 'http://192.168.1.8:5050'; // replace with your local IP
  }

  // ========== Staging & Production URLs ==========

  static const String _stagingApiUrl = 'https://api-staging.example.com';
  static const String _productionApiUrl = 'https://api.example.com';

  static const String _stagingSocketUrl = 'https://socket-staging.example.com';
  static const String _productionSocketUrl = 'https://socket.example.com';
}
