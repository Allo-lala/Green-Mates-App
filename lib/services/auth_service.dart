import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import '../core/utils/logger.dart';
import 'metamask_service.dart';

class User {
  final String id;
  final String walletAddress;
  final String? name;
  final String? email;
  final String? bio;
  final String? profileImage;
  final int ecoPoints;
  final double totalDonated;
  final int servicesUsed;
  final DateTime createdAt;
  final bool isAuthenticated;

  User({
    required this.id,
    required this.walletAddress,
    this.name,
    this.email,
    this.bio,
    this.profileImage,
    this.ecoPoints = 0,
    this.totalDonated = 0.0,
    this.servicesUsed = 0,
    required this.createdAt,
    this.isAuthenticated = false,
  });

  User copyWith({
    String? name,
    String? email,
    String? bio,
    String? profileImage,
    int? ecoPoints,
    double? totalDonated,
    int? servicesUsed,
  }) {
    return User(
      id: id,
      walletAddress: walletAddress,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
      ecoPoints: ecoPoints ?? this.ecoPoints,
      totalDonated: totalDonated ?? this.totalDonated,
      servicesUsed: servicesUsed ?? this.servicesUsed,
      createdAt: createdAt,
      isAuthenticated: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'walletAddress': walletAddress,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImage': profileImage,
      'ecoPoints': ecoPoints,
      'totalDonated': totalDonated,
      'servicesUsed': servicesUsed,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      walletAddress: json['walletAddress'] ?? '',
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
      profileImage: json['profileImage'],
      ecoPoints: json['ecoPoints'] ?? 0,
      totalDonated: (json['totalDonated'] as num?)?.toDouble() ?? 0.0,
      servicesUsed: json['servicesUsed'] ?? 0,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      isAuthenticated: true,
    );
  }
}

class AuthService {
  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;
  final MetaMaskService metaMaskService;

  AuthService({
    required this.prefs,
    required this.secureStorage,
    required this.metaMaskService,
  });

  /// Connect wallet via MetaMaskService
  Future<String?> connectMetaMask({BuildContext? context}) async {
    try {
      final walletAddress =
          await metaMaskService.connectWallet(context: context);
      if (walletAddress != null) {
        await secureStorage.write(key: 'wallet_address', value: walletAddress);
        AppLogger.i('Connected: $walletAddress');
      }
      return walletAddress;
    } catch (e) {
      AppLogger.e('MetaMask connection failed', e);
      return null;
    }
  }

  /// Check if wallet is connected
  Future<bool> isMetaMaskInstalled() async {
    return metaMaskService.isConnected;
  }

  /// Create user after wallet connection
  Future<User?> createUser(String walletAddress) async {
    try {
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final user = User(
        id: userId,
        walletAddress: walletAddress,
        createdAt: DateTime.now(),
        isAuthenticated: true,
      );

      await secureStorage.write(
          key: 'user_data', value: user.toJson().toString());
      await prefs.setString('user_id', userId);
      await prefs.setString('wallet_address', walletAddress);
      await prefs.setBool('is_authenticated', true);
      await prefs.setString('created_at', DateTime.now().toIso8601String());

      AppLogger.i('User created: $userId');
      return user;
    } catch (e) {
      AppLogger.e('User creation failed', e);
      return null;
    }
  }

  /// Get current user
  Future<User?> getCurrentUser() async {
    try {
      final userId = prefs.getString('user_id');
      final walletAddress = prefs.getString('wallet_address');
      final isAuthenticated = prefs.getBool('is_authenticated') ?? false;

      if (userId == null || walletAddress == null || !isAuthenticated) {
        return null;
      }

      return User(
        id: userId,
        walletAddress: walletAddress,
        name: prefs.getString('user_name'),
        email: prefs.getString('user_email'),
        bio: prefs.getString('user_bio'),
        profileImage: prefs.getString('user_profile_image'),
        ecoPoints: prefs.getInt('eco_points') ?? 0,
        totalDonated: prefs.getDouble('total_donated') ?? 0.0,
        servicesUsed: prefs.getInt('services_used') ?? 0,
        createdAt: DateTime.parse(
          prefs.getString('created_at') ?? DateTime.now().toIso8601String(),
        ),
        isAuthenticated: true,
      );
    } catch (e) {
      AppLogger.e('Error getting current user', e);
      return null;
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile({
    required String userId,
    String? name,
    String? email,
    String? bio,
    String? profileImage,
  }) async {
    try {
      if (name != null) await prefs.setString('user_name', name);
      if (email != null) await prefs.setString('user_email', email);
      if (bio != null) await prefs.setString('user_bio', bio);
      if (profileImage != null) {
        await prefs.setString('user_profile_image', profileImage);
      }
      AppLogger.i('Profile updated');
      return true;
    } catch (e) {
      AppLogger.e('Profile update failed', e);
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await metaMaskService.disconnect();
      await prefs.clear();
      await secureStorage.deleteAll();
      AppLogger.i('User signed out');
    } catch (e) {
      AppLogger.e('Sign out failed', e);
    }
  }

  /// Get wallet balances
  Future<Map<String, BigInt>> getWalletBalance() async {
    return await metaMaskService.getBalance();
  }
}
