import 'package:flutter/material.dart';

enum WalletType {
  metamask,
  coinbase,
  trustWallet,
  rainbowWallet,
  phantomWallet,
  rabbyWallet,
}

class WalletInfo {
  final WalletType type;
  final String name;
  final String displayName;
  final String logo;
  final Color primaryColor;
  final String deepLink;
  final bool isSupported;

  WalletInfo({
    required this.type,
    required this.name,
    required this.displayName,
    required this.logo,
    required this.primaryColor,
    required this.deepLink,
    required this.isSupported,
  });
}

class WalletConstants {
  static final Map<WalletType, WalletInfo> wallets = {
    WalletType.metamask: WalletInfo(
      type: WalletType.metamask,
      name: 'MetaMask',
      displayName: 'MetaMask',
      logo: 'assets/images/metamask_logo.png',
      primaryColor: const Color(0xFFF6851B),
      deepLink: 'https://metamask.app.link',
      isSupported: true,
    ),
    WalletType.coinbase: WalletInfo(
      type: WalletType.coinbase,
      name: 'Coinbase Wallet',
      displayName: 'Coinbase Wallet',
      logo: 'assets/images/coinbase.png',
      primaryColor: const Color(0xFF1652F0),
      deepLink: 'https://coinbase.com/wallet',
      isSupported: true,
    ),
    WalletType.trustWallet: WalletInfo(
      type: WalletType.trustWallet,
      name: 'Trust Wallet',
      displayName: 'Trust Wallet',
      logo: 'assets/images/trust.png',
      primaryColor: const Color.fromARGB(255, 51, 87, 187),
      deepLink: 'https://trustwallet.com',
      isSupported: true,
    ),
    WalletType.rainbowWallet: WalletInfo(
      type: WalletType.rainbowWallet,
      name: 'Rainbow',
      displayName: 'Rainbow Wallet',
      logo: 'assets/images/rainbow.png',
      primaryColor: const Color.fromARGB(255, 2, 0, 122),
      deepLink: 'https://rainbow.me',
      isSupported: true,
    ),
    WalletType.phantomWallet: WalletInfo(
      type: WalletType.phantomWallet,
      name: 'Phantom',
      displayName: 'Phantom Wallet',
      logo: 'assets/images/phantom.png',
      primaryColor: const Color(0xFFAB9FF2),
      deepLink: 'https://phantom.app',
      isSupported: true,
    ),
    WalletType.rabbyWallet: WalletInfo(
      type: WalletType.rabbyWallet,
      name: 'Rabby Wallet',
      displayName: 'Rabby Wallet',
      logo: 'assets/images/rabby.png',
      primaryColor: const Color(0xFF8084FF),
      deepLink: 'https://rabby.io',
      isSupported: true,
    ),
  };

  static WalletInfo? getWalletInfo(WalletType type) {
    return wallets[type];
  }

  static List<WalletInfo> getSupportedWallets() {
    return wallets.values.where((w) => w.isSupported).toList();
  }
}
