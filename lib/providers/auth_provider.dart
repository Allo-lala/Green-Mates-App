// ignore_for_file: use_build_context_synchronously

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/metamask_service.dart';

// Auth service provider
final authServiceProvider = FutureProvider<AuthService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();
  final metaMaskService = MetaMaskService();
  return AuthService(
    prefs: prefs,
    secureStorage: secureStorage,
    metaMaskService: metaMaskService,
  );
});

// Current user provider
final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier(ref);
});

class CurrentUserNotifier extends StateNotifier<User?> {
  final Ref ref;

  CurrentUserNotifier(this.ref) : super(null) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    try {
      final authService = await ref.read(authServiceProvider.future);
      final user = await authService.getCurrentUser();
      state = user;
    } catch (_) {
      state = null;
    }
  }

  Future<bool> connectWallet({BuildContext? context}) async {
    try {
      final authService = await ref.read(authServiceProvider.future);
      final walletAddress = await authService.connectMetaMask(context: context);
      if (walletAddress == null) return false;

      final user = await authService.createUser(walletAddress);
      if (user != null) {
        state = user;
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? bio,
    String? profileImage,
  }) async {
    if (state == null) return false;
    try {
      final authService = await ref.read(authServiceProvider.future);
      final success = await authService.updateUserProfile(
        userId: state!.id,
        name: name,
        email: email,
        bio: bio,
        profileImage: profileImage,
      );

      if (success) {
        state = state!.copyWith(
          name: name,
          email: email,
          bio: bio,
          profileImage: profileImage,
        );
      }
      return success;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      final authService = await ref.read(authServiceProvider.future);
      await authService.signOut();
      state = null;
    } catch (_) {}
  }
}
