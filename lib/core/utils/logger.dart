import 'package:flutter/foundation.dart';

class AppLogger {
  static void i(String message, [dynamic data]) {
    if (kDebugMode) {
      debugPrint('🟢 INFO: $message${data != null ? ' → $data' : ''}');
    }
  }

  static void e(String message, [dynamic error]) {
    if (kDebugMode) {
      debugPrint('🔴 ERROR: $message${error != null ? ' → $error' : ''}');
    }
  }

  static void w(String message, [dynamic data]) {
    if (kDebugMode) {
      debugPrint('🟠 WARNING: $message${data != null ? ' → $data' : ''}');
    }
  }

  static void d(String message, [dynamic data]) {
    if (kDebugMode) {
      debugPrint('🔵 DEBUG: $message${data != null ? ' → $data' : ''}');
    }
  }
}
