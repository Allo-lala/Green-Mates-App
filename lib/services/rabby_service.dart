// ignore_for_file: unused_field

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class RabbyException implements Exception {
  final String message;
  RabbyException(this.message);

  @override
  String toString() => message;
}

class RabbyService {
  static const String _rabbyConnectUrl = 'https://rabby.io/connect';
  InAppWebViewController? _webViewController;
  String? _connectedAddress;

  Future<void> initialize() async {
    // Initialize anything needed for Rabby
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<String?> connectWallet({required BuildContext context}) async {
    try {
      Completer<String?> completer = Completer<String?>();
      String? connectedAddress;

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: double.infinity,
              height: 500,
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(_rabbyConnectUrl)),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStop: (controller, url) async {
                  // Check if the wallet has connected (mock)
                  if (url.toString().contains("connected")) {
                    connectedAddress =
                        '0x1234567890123456789012345678901234567890';
                    if (!completer.isCompleted) {
                      completer.complete(connectedAddress);
                    }
                    Navigator.of(ctx).pop();
                  }
                },
                // ignore: deprecated_member_use
                onLoadError: (controller, url, code, message) {
                  if (!completer.isCompleted) {
                    completer.completeError(
                      RabbyException('Failed to load Rabby page: $message'),
                    );
                  }
                  Navigator.of(ctx).pop();
                },
              ),
            ),
          );
        },
      );

      _connectedAddress = await completer.future;
      return _connectedAddress;
    } catch (e) {
      throw RabbyException('Failed to connect Rabby Wallet: ${e.toString()}');
    }
  }

  Future<String?> getBalance(String address) async {
    try {
      // Replace this with a call to your blockchain provider
      return '0.00 ETH';
    } catch (e) {
      throw RabbyException('Failed to fetch balance: ${e.toString()}');
    }
  }

  Future<void> disconnect() async {
    _connectedAddress = null;
  }
}
