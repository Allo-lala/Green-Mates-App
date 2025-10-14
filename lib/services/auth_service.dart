// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/utils/logger.dart';

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
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      isAuthenticated: true,
    );
  }
}

class AuthService {
  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;

  AuthService({
    required this.prefs,
    required this.secureStorage,
  });

  // Mock MetaMask connection
  Future<String?> connectMetaMask() async {
    try {
      AppLogger.i('Connecting to MetaMask...');

      // Simulate wallet connection
      await Future.delayed(const Duration(seconds: 2));

      // Generate or use mock address
      const mockAddress = '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';

      // In production, this would use actual MetaMask integration
      await secureStorage.write(
        key: 'wallet_address',
        value: mockAddress,
      );

      AppLogger.i('Connected: $mockAddress');
      return mockAddress;
    } catch (e) {
      AppLogger.e('MetaMask connection failed', e);
      return null;
    }
  }

  // Create user after wallet connection
  Future<User?> createUser(String walletAddress) async {
    try {
      final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

      final user = User(
        id: userId,
        walletAddress: walletAddress,
        createdAt: DateTime.now(),
        isAuthenticated: true,
      );

      // Save user to secure storage
      await secureStorage.write(
        key: 'user_data',
        value: user.toJson().toString(),
      );

      // Save to preferences
      await prefs.setString('user_id', userId);
      await prefs.setString('wallet_address', walletAddress);
      await prefs.setBool('is_authenticated', true);

      AppLogger.i('User created: $userId');
      return user;
    } catch (e) {
      AppLogger.e('User creation failed', e);
      return null;
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final userId = prefs.getString('user_id');
      final walletAddress = prefs.getString('wallet_address');

      if (userId == null || walletAddress == null) {
        return null;
      }

      final isAuthenticated = prefs.getBool('is_authenticated') ?? false;

      if (!isAuthenticated) {
        return null;
      }

      // In production, fetch from Firestore
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

  // Update user profile
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

  // Sign out
  Future<void> signOut() async {
    try {
      await prefs.remove('user_id');
      await prefs.remove('wallet_address');
      await prefs.remove('is_authenticated');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      await prefs.remove('user_bio');
      await prefs.remove('user_profile_image');
      await secureStorage.delete(key: 'wallet_address');

      AppLogger.i('User signed out');
    } catch (e) {
      AppLogger.e('Sign out failed', e);
    }
  }

  // Check if user is authenticated
  bool isUserAuthenticated() {
    return prefs.getBool('is_authenticated') ?? false;
  }

  // Get wallet address
  String? getWalletAddress() {
    return prefs.getString('wallet_address');
  }
}
