// ignore_for_file: use_build_context_synchronously, prefer_conditional_assignment

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
  await metaMaskService.initialize(); // initialize before using

  return AuthService(
    prefs: prefs,
    secureStorage: secureStorage,
    metaMaskService: metaMaskService,
  );
});

// Current user provider with persistence
final currentUserProvider =
    StateNotifierProvider<CurrentUserNotifier, User?>((ref) {
  return CurrentUserNotifier(ref);
});

// Session notifier for managing login state
final sessionProvider = StateNotifierProvider<SessionNotifier, bool>((ref) {
  return SessionNotifier(ref);
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

  Future<bool> connectWallet({
    BuildContext? context,
    required String walletType,
    String? address,
  }) async {
    try {
      final authService = await ref.read(authServiceProvider.future);

      String? walletAddress = address;

      if (walletAddress == null) {
        walletAddress = await authService.connectMetaMask(context: context);
      }

      if (walletAddress == null) return false;

      // Create or retrieve user with wallet info
      final user = await authService.createUser(walletAddress, walletType);
      if (user != null) {
        state = user;
        await authService.persistUserSession(user);
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
        await authService.persistUserSession(state!);
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
      await authService.clearUserSession();
      state = null;
    } catch (_) {}
  }

  Future<bool> restoreSession() async {
    try {
      final authService = await ref.read(authServiceProvider.future);
      final user = await authService.getCurrentUser();
      if (user != null) {
        state = user;
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

class SessionNotifier extends StateNotifier<bool> {
  final Ref ref;
  SessionNotifier(this.ref) : super(false) {
    _initializeSession();
  }

  Future<void> _initializeSession() async {
    try {
      final user = ref.read(currentUserProvider);
      state = user != null;
    } catch (_) {
      state = false;
    }
  }

  void updateSession(bool isLoggedIn) {
    state = isLoggedIn;
  }
}
