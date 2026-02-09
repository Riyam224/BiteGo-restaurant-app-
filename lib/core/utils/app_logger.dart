import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized logging utility for the entire app
///
/// Provides consistent logging across all features with:
/// - Color-coded console output
/// - Automatic debug/release mode handling
/// - Structured log levels (debug, info, warning, error)
/// - Stack trace support for errors
///
/// Usage:
/// ```dart
/// AppLogger.info('User logged in successfully');
/// AppLogger.error('API call failed', error: exception, stackTrace: stack);
/// ```
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // Number of method calls to display
      errorMethodCount: 8, // Number of method calls if stacktrace is provided
      lineLength: 120, // Width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    // Only log in debug mode for performance
    level: kDebugMode ? Level.debug : Level.off,
  );

  /// Log debug information (development only)
  ///
  /// Use for detailed information useful during development
  /// Example: AppLogger.debug('User tapped login button');
  static void debug(dynamic message) {
    if (kDebugMode) {
      _logger.d(message);
    }
  }

  /// Log general information
  ///
  /// Use for important events that should be logged
  /// Example: AppLogger.info('User authentication successful');
  static void info(dynamic message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  /// Log warnings
  ///
  /// Use for potentially harmful situations
  /// Example: AppLogger.warning('API response took longer than expected');
  static void warning(dynamic message) {
    if (kDebugMode) {
      _logger.w(message);
    }
  }

  /// Log errors
  ///
  /// Use for error events that might still allow the app to continue
  /// Example: AppLogger.error('Failed to load user profile', error: exception);
  static void error(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log API requests
  ///
  /// Specialized logging for HTTP requests
  static void apiRequest(String method, String endpoint, {dynamic data}) {
    if (kDebugMode) {
      _logger.i('🌐 API REQUEST → $method $endpoint', error: data);
    }
  }

  /// Log API responses
  ///
  /// Specialized logging for HTTP responses
  static void apiResponse(int statusCode, String endpoint, {dynamic data}) {
    if (kDebugMode) {
      if (statusCode >= 200 && statusCode < 300) {
        _logger.i('✅ API SUCCESS → $statusCode $endpoint', error: data);
      } else {
        _logger.w('⚠️ API WARNING → $statusCode $endpoint', error: data);
      }
    }
  }

  /// Log API errors
  ///
  /// Specialized logging for HTTP errors
  static void apiError(String endpoint, dynamic error, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      _logger.e('❌ API ERROR → $endpoint', error: error, stackTrace: stackTrace);
    }
  }

  /// Log authentication events
  ///
  /// Specialized logging for auth-related events
  static void auth(String message) {
    if (kDebugMode) {
      _logger.i('🔐 AUTH → $message');
    }
  }

  /// Log navigation events
  ///
  /// Specialized logging for navigation
  static void navigation(String message) {
    if (kDebugMode) {
      _logger.i('🧭 NAVIGATION → $message');
    }
  }
}
