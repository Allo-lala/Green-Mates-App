// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../core/utils/logger.dart';

class RainbowSimulatorService {
  String? _connectedAddress;
  bool _isConnecting = false;

  String? get connectedAddress => _connectedAddress;
  bool get isConnected => _connectedAddress != null;

  /// Simulated Rainbow Wallet connection for Android testing
  Future<String?> connectWallet({required BuildContext context}) async {
    if (_isConnecting) {
      throw Exception('Connection already in progress.');
    }

    _isConnecting = true;

    try {
      // Show Rainbow connection dialog
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext ctx) => _RainbowConnectDialog(),
      );

      if (!context.mounted) return null;

      if (result == true) {
        // Simulate successful connection
        _connectedAddress = _generateMockAddress();
        await _triggerHapticSuccess();
        AppLogger.i('Rainbow simulator connected: $_connectedAddress');
        return _connectedAddress;
      }

      return null;
    } finally {
      _isConnecting = false;
    }
  }

  /// Generate mock Ethereum address for testing
  String _generateMockAddress() {
    const chars = '0x12QGQ5YDy7qTrBKKd8jEaqNVrksKj';
    final random = Random();
    return '0x' +
        List.generate(40, (index) => chars[random.nextInt(chars.length)])
            .join();
  }

  /// Haptic feedback on success
  Future<void> _triggerHapticSuccess() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 50);
      }
    } catch (_) {}
  }

  /// Disconnect wallet
  Future<void> disconnect() async {
    _connectedAddress = null;
    _isConnecting = false;
    AppLogger.i('Rainbow simulator disconnected');
  }
}

class _RainbowConnectDialog extends StatefulWidget {
  @override
  State<_RainbowConnectDialog> createState() => _RainbowConnectDialogState();
}

class _RainbowConnectDialogState extends State<_RainbowConnectDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rainbow logo/icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF1D5E),
                    Color(0xFFFA5723),
                    Color(0xFFFFC107)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.account_balance_wallet,
                  color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'Connect Rainbow Wallet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Approve connection to GreenMates',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7F8C8D),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _handleApprove,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF1D5E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Approve',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFECF0F1),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApprove() async {
    setState(() => _isLoading = true);

    // Simulate connection delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pop(context, true);
  }
}
