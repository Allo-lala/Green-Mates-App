import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/kyc_service.dart';

final kycServiceProvider = FutureProvider<KYCService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  return KYCService(
    prefs: prefs,
    secureStorage: secureStorage,
  );
});

final kycCompletionProvider =
    StateNotifierProvider<KYCCompletionNotifier, bool>((ref) {
  return KYCCompletionNotifier(ref);
});

class KYCCompletionNotifier extends StateNotifier<bool> {
  final Ref ref;

  KYCCompletionNotifier(this.ref) : super(false) {
    _checkKYCStatus();
  }

  Future<void> _checkKYCStatus() async {
    // Check if current user has completed KYC
    state = false; // Default to incomplete
  }
}
