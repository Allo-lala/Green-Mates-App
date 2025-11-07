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
  int _connectionAttempts = 0;
  static const int _maxRetries = 3;
  bool _isConnecting = false;
  Timer? _connectionTimeout;

  bool get isConnected => _connectedAddress != null;
  String? get connectedAddress => _connectedAddress;

  Future<void> initialize() async {
    _client = Web3Client(AppConstants.celoMainnetRpcUrl, Client());

    _connector = await Web3App.createInstance(
      projectId: AppConstants.walletConnectProjectId,
      relayUrl: 'wss://relay.walletconnect.com',
      metadata: const PairingMetadata(
        name: 'Grin Mates',
        description: 'Eco-friendly DApp built with Flutter',
        url: 'https://grinmates.app',
        icons: ['https://grinmates.app/icon.png'],
      ),
    );

    AppLogger.i('WalletConnect v2 initialized');
  }

  Future<String?> connectWallet({BuildContext? context}) async {
    if (_isConnecting) {
      AppLogger.w('Connection already in progress');
      throw ConnectionException('Connection already in progress. Please wait.');
    }

    _isConnecting = true;
    _connectionAttempts = 0;

    try {
      while (_connectionAttempts < _maxRetries) {
        try {
          _connector ??= await Web3App.createInstance(
            projectId: AppConstants.walletConnectProjectId,
            relayUrl: 'wss://relay.walletconnect.com',
            metadata: const PairingMetadata(
              name: 'Grin Mates',
              description: 'Eco-friendly DApp built with Flutter',
              url: 'https://grinmates.app',
              icons: ['https://grinmates.app/icon.png'],
            ),
          );

          final connectResponse = await _connector!.connect(
            optionalNamespaces: {
              'eip155': RequiredNamespace(
                chains: ['eip155:42220'],
                methods: ['eth_sendTransaction', 'personal_sign'],
                events: ['accountsChanged', 'chainChanged'],
              ),
            },
          ).timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              throw ConnectionException(
                  'Failed to generate connection URI. Please try again.');
            },
          );

          final uri = connectResponse.uri;
          if (uri != null && context != null) {
            if (!kIsWeb) {
              final metamaskUri = Uri.parse(
                'https://metamask.app.link/wc?uri=${Uri.encodeComponent(uri.toString())}',
              );

              if (await canLaunchUrl(metamaskUri)) {
                await launchUrl(metamaskUri,
                    mode: LaunchMode.externalApplication);
              } else {
                throw ConnectionException(
                    'MetaMask is not installed. Please install it first.');
              }
            }
          }

          _connectionTimeout = Timer(const Duration(seconds: 60), () {
            if (_session == null) {
              throw ConnectionException(
                  'Session confirmation timeout. Please try again.');
            }
          });

          final session = await connectResponse.session.future;

          _connectionTimeout?.cancel();
          _session = session;

          final acct = session.namespaces['eip155']?.accounts.first;
          if (acct != null) {
            final addressHex = acct.split(':').last;
            _connectedAddress = addressHex;
            _ethereumAddress = EthereumAddress.fromHex(addressHex);
            AppLogger.i('Wallet connected: $_connectedAddress');

            await _triggerHapticSuccess();
            return _connectedAddress;
          }

          throw ConnectionException('Failed to extract wallet address.');
        } on ConnectionException catch (e) {
          _connectionTimeout?.cancel();
          _connectionAttempts++;
          AppLogger.e(
              'Connection attempt $_connectionAttempts failed: ${e.message}',
              e);

          if (_connectionAttempts >= _maxRetries) {
            throw ConnectionException(
                'Failed to connect after $_maxRetries attempts: ${e.message}');
          }

          await Future.delayed(Duration(seconds: _connectionAttempts * 2));
        } catch (e) {
          _connectionTimeout?.cancel();
          _connectionAttempts++;
          AppLogger.e('Wallet connection error', e);

          if (_connectionAttempts >= _maxRetries) {
            throw ConnectionException('Connection error: ${e.toString()}');
          }

          await Future.delayed(Duration(seconds: _connectionAttempts * 2));
        }
      }

      return null;
    } finally {
      _isConnecting = false;
      _connectionTimeout?.cancel();
    }
  }

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

  Future<bool> isMetaMaskInstalled() async {
    return _connector != null;
  }

  Future<String?> connectMetaMask() async {
    return await connectWallet();
  }

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
    _connectionTimeout?.cancel();
    AppLogger.i('Wallet disconnected');
  }

  void dispose() {
    _client?.dispose();
    _connectionTimeout?.cancel();
  }

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
