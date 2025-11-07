import 'package:vibration/vibration.dart';

class HapticService {
  /// Light tap feedback - used for standard button presses
  static Future<void> lightTap() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 20);
      }
    } catch (_) {}
  }

  /// Medium tap - used for form submissions and important actions
  static Future<void> mediumTap() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 30);
      }
    } catch (_) {}
  }

  /// Strong tap - used for successful transactions
  static Future<void> strongTap() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 50);
      }
    } catch (_) {}
  }

  /// Success pattern - multiple pulses indicating successful action
  static Future<void> success() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(pattern: [0, 50, 100, 50]);
      }
    } catch (_) {}
  }

  /// Error pattern - double pulse indicating error
  static Future<void> error() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(pattern: [0, 100, 50, 100]);
      }
    } catch (_) {}
  }

  /// Warning pattern - slow pulse indicating caution
  static Future<void> warning() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(pattern: [0, 150, 100, 150]);
      }
    } catch (_) {}
  }

  /// Double tap - used for important confirmations
  static Future<void> doubleTap() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(pattern: [0, 30, 40, 30]);
      }
    } catch (_) {}
  }

  /// Page transition feedback
  static Future<void> pageTransition() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 15);
      }
    } catch (_) {}
  }
}
