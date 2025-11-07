import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static const String celoMainnetRpcUrl = 'https://forno.celo.org';
  static const String cUSDTokenAddress =
      '0x765DE816845861e75A25fCA122bb6898B8B1282a';

  static String get walletConnectProjectId =>
      dotenv.env['WALLET_CONNECT_PROJECT_ID'] ??
      'af21ed1a1e214a1da82c10f517987fa0';
}
