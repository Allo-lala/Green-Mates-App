// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import '../core/constants/wallet_constants.dart';

abstract class BaseWalletService {
  Future<void> initialize();
  Future<String?> connectWallet({required BuildContext context});
  Future<bool> isInstalled();
  Future<String?> getBalance(String address);
  Future<String> sendTransaction(String to, String amount);
  Future<void> disconnect();
}

class MetaMaskWalletService extends BaseWalletService {
  String? _connectedAddress;
  late String _projectId;

  MetaMaskWalletService(this._projectId);

  @override
  Future<void> initialize() async {
    // MetaMask initialization handled by metamask_service.dart
  }

  @override
  Future<String?> connectWallet({required BuildContext context}) async {
    try {
      // Uses existing metamask_service.dart
      return _connectedAddress;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isInstalled() async {
    // Check if MetaMask is installed
    return true;
  }

  @override
  Future<String?> getBalance(String address) async {
    try {
      // Get balance from blockchain
      return '0.0';
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> sendTransaction(String to, String amount) async {
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() async {
    _connectedAddress = null;
  }
}

class CoinbaseWalletService extends BaseWalletService {
  String? _connectedAddress;
  late String _projectId;

  CoinbaseWalletService(this._projectId);

  @override
  Future<void> initialize() async {
    // Coinbase Wallet initialization
  }

  @override
  Future<String?> connectWallet({required BuildContext context}) async {
    try {
      // Coinbase connection logic
      // This would typically use the Coinbase Wallet SDK
      return _connectedAddress;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isInstalled() async {
    // Check if Coinbase Wallet is installed
    return true;
  }

  @override
  Future<String?> getBalance(String address) async {
    try {
      return '0.0';
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> sendTransaction(String to, String amount) async {
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() async {
    _connectedAddress = null;
  }
}

class TrustWalletService extends BaseWalletService {
  String? _connectedAddress;
  late String _projectId;

  TrustWalletService(this._projectId);

  @override
  Future<void> initialize() async {
    // Trust Wallet initialization
  }

  @override
  Future<String?> connectWallet({required BuildContext context}) async {
    try {
      // Trust Wallet connection logic
      return _connectedAddress;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isInstalled() async {
    // Check if Trust Wallet is installed
    return true;
  }

  @override
  Future<String?> getBalance(String address) async {
    try {
      return '0.0';
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> sendTransaction(String to, String amount) async {
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() async {
    _connectedAddress = null;
  }
}

class RabbyWalletService extends BaseWalletService {
  String? _connectedAddress;
  late String _projectId;

  RabbyWalletService(this._projectId);

  @override
  Future<void> initialize() async {
    // Rabby Wallet initialization
  }

  @override
  Future<String?> connectWallet({required BuildContext context}) async {
    try {
      // Rabby Wallet connection logic
      return _connectedAddress;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isInstalled() async {
    // Check if Rabby Wallet is installed
    return true;
  }

  @override
  Future<String?> getBalance(String address) async {
    try {
      return '0.0';
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> sendTransaction(String to, String amount) async {
    throw UnimplementedError();
  }

  @override
  Future<void> disconnect() async {
    _connectedAddress = null;
  }
}

class WalletServiceFactory {
  static BaseWalletService createService(
    WalletType type,
    String projectId,
  ) {
    switch (type) {
      case WalletType.metamask:
        return MetaMaskWalletService(projectId);
      case WalletType.coinbase:
        return CoinbaseWalletService(projectId);
      case WalletType.trustWallet:
        return TrustWalletService(projectId);
      case WalletType.rainbowWallet:
        return MetaMaskWalletService(projectId);
      case WalletType.phantomWallet:
        return MetaMaskWalletService(
            projectId); // Phantom uses similar protocol
      case WalletType.rabbyWallet:
        return RabbyWalletService(projectId);
    }
  }
}
