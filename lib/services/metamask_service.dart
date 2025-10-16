// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/logger.dart';

class MetaMaskService {
  Web3Client? _client;
  String? _connectedAddress;
  EthereumAddress? _ethereumAddress;

  Web3App? _connector; // deprecated, but keep for now
  SessionData? _session;

  bool get isConnected => _connectedAddress != null;
  String? get connectedAddress => _connectedAddress;

  Future<void> initialize() async {
    _client = Web3Client(AppConstants.celoMainnetRpcUrl, Client());

    _connector = await Web3App.createInstance(
      projectId: 'af21ed1a1e214a1da82c10f517987fa0', // WalletConnect Project ID
      relayUrl: 'wss://relay.walletconnect.com',
      metadata: const PairingMetadata(
        name: 'GoGreen Mates',
        description: 'Eco-friendly DApp built with Flutter',
        url: 'https://gogreenmates.app',
        icons: ['https://gogreenmates.app/icon.png'],
      ),
    );

    AppLogger.i('WalletConnect v2 initialized');
  }

  Future<String?> connectWallet({BuildContext? context}) async {
    try {
      _connector ??= await Web3App.createInstance(
        projectId: 'af21ed1a1e214a1da82c10f517987fa0',
        relayUrl: 'wss://relay.walletconnect.com',
        metadata: const PairingMetadata(
          name: 'GoGreen Mates',
          description: 'Eco-friendly DApp built with Flutter',
          url: 'https://gogreenmates.app',
          icons: ['https://gogreenmates.app/icon.png'],
        ),
      );

      final connectResponse = await _connector!.connect(
        optionalNamespaces: {
          'eip155': RequiredNamespace(
            chains: ['eip155:1'],
            methods: ['eth_sendTransaction', 'personal_sign'],
            events: ['accountsChanged', 'chainChanged'],
          ),
        },
      );

      final uri = connectResponse.uri;
      if (uri != null && context != null) {
        if (!kIsWeb) {
          final metamaskUri = Uri.parse(
            'https://metamask.app.link/wc?uri=${Uri.encodeComponent(uri.toString())}',
          );
          await launchUrl(metamaskUri, mode: LaunchMode.externalApplication);
        } else {
          AppLogger.i('Scan this WalletConnect QR: ${uri.toString()}');
        }
      }

      final session = await connectResponse.session.future;
      _session = session;

      final acct = session.namespaces['eip155']?.accounts.first;
      if (acct != null) {
        final addressHex = acct.split(':').last;
        _connectedAddress = addressHex;
        _ethereumAddress = EthereumAddress.fromHex(addressHex);
        AppLogger.i('Wallet connected: $_connectedAddress');
      }

      return _connectedAddress;
    } catch (e) {
      AppLogger.e('Wallet connection failed', e);
      return null;
    }
  }

  Future<bool> isMetaMaskInstalled() async {
    return _connector != null;
  }

  /// Simple wrapper for AuthService
  Future<String?> connectMetaMask() async {
    // just call connectWallet without a BuildContext (context is optional)
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
        chainId: 'eip155:1',
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [message, _connectedAddress],
        ),
      );
      AppLogger.i('Message signed: $result');
      return result;
    } catch (e) {
      AppLogger.e('Error signing message', e);
      return null;
    }
  }

  Future<void> disconnect() async {
    if (_session != null && _connector != null) {
      await _connector!.disconnectSession(
        topic: _session!.topic,
        reason: Errors.getSdkError(Errors.USER_DISCONNECTED), // required now
      );
    }
    _session = null;
    _connectedAddress = null;
    _ethereumAddress = null;
    AppLogger.i('Wallet disconnected');
  }

  void dispose() {
    _client?.dispose();
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
