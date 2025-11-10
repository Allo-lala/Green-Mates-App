// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import 'package:vibration/vibration.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';

class ConnectionException implements Exception {
  final String message;
  ConnectionException(this.message);
  @override
  String toString() => message;
}

class MetaMaskService {
  Web3Client? _client;
  String? _connectedAddress;
  EthereumAddress? _ethereumAddress;
  Web3App? _connector;
  SessionData? _session;
  bool _isConnecting = false;

  bool get isConnected => _connectedAddress != null;
  String? get connectedAddress => _connectedAddress;

  /// Initialize WalletConnect and the Web3 client
  Future<void> initialize() async {
    _client = Web3Client(AppConstants.celoMainnetRpcUrl, Client());

    _connector = await Web3App.createInstance(
      projectId: AppConstants.walletConnectProjectId,
      relayUrl: 'wss://relay.walletconnect.com',
      metadata: const PairingMetadata(
        name: 'Grin Mates',
        description: 'Eco-friendly DApp built with Flutter',
        url: 'https://grinmates.vercel.app',
        icons: ['https://grinmates.app/icon.png'],
      ),
    );

    AppLogger.i('WalletConnect v2 initialized');
  }

  /// Connect wallet and return connected address
  Future<String?> connectWallet({BuildContext? context}) async {
    if (_isConnecting) {
      throw ConnectionException('Connection already in progress.');
    }

    _isConnecting = true;

    try {
      if (_connector == null) {
        await initialize();
      }

      final connectResponse = await _connector!.connect(
        optionalNamespaces: {
          'eip155': RequiredNamespace(
            chains: ['eip155:42220'],
            methods: ['eth_sendTransaction', 'personal_sign'],
            events: ['accountsChanged', 'chainChanged'],
          ),
        },
      );

      final uri = connectResponse.uri;
      if (uri != null && context != null && !kIsWeb) {
        final deepLink = Uri.parse(
            'metamask://wc?uri=${Uri.encodeComponent(uri.toString())}');
        if (await canLaunchUrl(deepLink)) {
          await launchUrl(deepLink, mode: LaunchMode.externalApplication);
        } else {
          // fallback to web link
          final webFallback = Uri.parse(
              'https://metamask.app.link/wc?uri=${Uri.encodeComponent(uri.toString())}');
          if (await canLaunchUrl(webFallback)) {
            await launchUrl(webFallback, mode: LaunchMode.externalApplication);
          } else {
            throw ConnectionException(
                'MetaMask is not installed or cannot be launched.');
          }
        }
      }

      // Wait for user to approve the session
      final session = await connectResponse.session.future.timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw ConnectionException(
              'Session confirmation timeout. Please try again.');
        },
      );

      _session = session;

      final acct = session.namespaces['eip155']?.accounts.first;
      if (acct != null) {
        _connectedAddress = acct.split(':').last;
        _ethereumAddress = EthereumAddress.fromHex(_connectedAddress!);
        await _triggerHapticSuccess();
        AppLogger.i('Wallet connected: $_connectedAddress');
        return _connectedAddress;
      }

      throw ConnectionException('Failed to extract wallet address.');
    } finally {
      _isConnecting = false;
    }
  }

  /// Check if MetaMask is installed
  Future<bool> isMetaMaskInstalled() async {
    return _connector != null;
  }

  /// Connect MetaMask shortcut
  Future<String?> connectMetaMask() async {
    return await connectWallet();
  }

  /// Get CELO and cUSD balances
  Future<Map<String, BigInt>> getBalance() async {
    if (_client == null || _ethereumAddress == null) {
      return {'CELO': BigInt.zero, 'cUSD': BigInt.zero};
    }

    try {
      final celoBal = await _client!.getBalance(_ethereumAddress!);
      final cUsdBal = await _getTokenBalance(
        AppConstants.cUSDTokenAddress,
        _ethereumAddress!,
      );
      return {'CELO': celoBal.getInWei, 'cUSD': cUsdBal};
    } catch (e) {
      AppLogger.e('Error getting balances', e);
      return {'CELO': BigInt.zero, 'cUSD': BigInt.zero};
    }
  }

  /// Internal: get ERC20 token balance
  Future<BigInt> _getTokenBalance(
      String tokenAddress, EthereumAddress walletAddress) async {
    try {
      final contract = DeployedContract(
        ContractAbi.fromJson(_erc20Abi, 'ERC20'),
        EthereumAddress.fromHex(tokenAddress),
      );
      final balanceFunction = contract.function('balanceOf');
      final result = await _client!.call(
        contract: contract,
        function: balanceFunction,
        params: [walletAddress],
      );
      return result.first as BigInt;
    } catch (e) {
      AppLogger.e('Error fetching token balance', e);
      return BigInt.zero;
    }
  }

  /// Sign a message with MetaMask
  Future<String?> signMessage(String message) async {
    if (_session == null || _connector == null) {
      AppLogger.w('No wallet connected');
      return null;
    }

    try {
      final result = await _connector!.request(
        topic: _session!.topic,
        chainId: 'eip155:42220',
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [message, _connectedAddress],
        ),
      );

      await _triggerHapticSuccess();
      AppLogger.i('Message signed: $result');
      return result;
    } catch (e) {
      await _triggerHapticError();
      AppLogger.e('Error signing message', e);
      return null;
    }
  }

  /// Disconnect wallet
  Future<void> disconnect() async {
    if (_session != null && _connector != null) {
      await _connector!.disconnectSession(
        topic: _session!.topic,
        reason: Errors.getSdkError(Errors.USER_DISCONNECTED),
      );
    }

    _session = null;
    _connectedAddress = null;
    _ethereumAddress = null;
    _isConnecting = false;
    AppLogger.i('Wallet disconnected');
  }

  /// Dispose resources
  void dispose() {
    _client?.dispose();
  }

  /// Haptic feedback helpers
  Future<void> _triggerHapticSuccess() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 50);
      }
    } catch (_) {}
  }

  Future<void> _triggerHapticError() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(
          pattern: [0, 100, 50, 100],
          intensities: [0, 128, 0, 255],
        );
      }
    } catch (_) {}
  }

  /// ERC20 ABI
  static const String _erc20Abi = '''
  [
    {
      "constant": true,
      "inputs": [{"name": "_owner", "type": "address"}],
      "name": "balanceOf",
      "outputs": [{"name": "balance", "type": "uint256"}],
      "type": "function"
    }
  ]
  ''';
}
