// import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/utils/logger.dart';

class KYCData {
  final String firstName;
  final String lastName;
  final String email;
  final String dateOfBirth; // Format: yyyy-MM-dd
  final String nationality;
  final String address;
  final String city;
  final String postalCode;
  final String country;
  final String? identityDocumentPath; // Path to ID document
  final String? proofOfAddressPath; // Path to proof of address
  final String? selfieWithIdPath; // Path to selfie with ID
  final String status; // pending, approved, rejected
  final DateTime createdAt;
  final DateTime? completedAt;

  KYCData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dateOfBirth,
    required this.nationality,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    this.identityDocumentPath,
    this.proofOfAddressPath,
    this.selfieWithIdPath,
    this.status = 'pending',
    required this.createdAt,
    this.completedAt,
  });

  bool get isComplete =>
      firstName.isNotEmpty &&
      lastName.isNotEmpty &&
      email.isNotEmpty &&
      dateOfBirth.isNotEmpty &&
      nationality.isNotEmpty &&
      address.isNotEmpty &&
      identityDocumentPath != null &&
      proofOfAddressPath != null &&
      selfieWithIdPath != null;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'dateOfBirth': dateOfBirth,
        'nationality': nationality,
        'address': address,
        'city': city,
        'postalCode': postalCode,
        'country': country,
        'identityDocumentPath': identityDocumentPath,
        'proofOfAddressPath': proofOfAddressPath,
        'selfieWithIdPath': selfieWithIdPath,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory KYCData.fromJson(Map<String, dynamic> json) => KYCData(
        firstName: json['firstName'] ?? '',
        lastName: json['lastName'] ?? '',
        email: json['email'] ?? '',
        dateOfBirth: json['dateOfBirth'] ?? '',
        nationality: json['nationality'] ?? '',
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        postalCode: json['postalCode'] ?? '',
        country: json['country'] ?? '',
        identityDocumentPath: json['identityDocumentPath'],
        proofOfAddressPath: json['proofOfAddressPath'],
        selfieWithIdPath: json['selfieWithIdPath'],
        status: json['status'] ?? 'pending',
        createdAt: DateTime.parse(
            json['createdAt'] ?? DateTime.now().toIso8601String()),
        completedAt: json['completedAt'] != null
            ? DateTime.parse(json['completedAt'])
            : null,
      );
}

class KYCService {
  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;

  KYCService({
    required this.prefs,
    required this.secureStorage,
  });

  Future<bool> saveKYCData(String userId, KYCData kycData) async {
    try {
      await secureStorage.write(
        key: 'kyc_data_$userId',
        value: kycData.toJson().toString(),
      );
      await prefs.setString('kyc_status_$userId', kycData.status);
      await prefs.setString(
          'kyc_completed_at_$userId', DateTime.now().toIso8601String());
      AppLogger.i('KYC data saved for user $userId');
      return true;
    } catch (e) {
      AppLogger.e('Error saving KYC data', e);
      return false;
    }
  }

  Future<KYCData?> getKYCData(String userId) async {
    try {
      final kycJson = await secureStorage.read(key: 'kyc_data_$userId');
      if (kycJson == null) return null;
      // Parse from string representation
      AppLogger.i('KYC data retrieved for user $userId');
      return null; // In production, parse the JSON properly
    } catch (e) {
      AppLogger.e('Error retrieving KYC data', e);
      return null;
    }
  }

  Future<bool> isKYCCompleted(String userId) async {
    try {
      final status = prefs.getString('kyc_status_$userId');
      return status == 'approved';
    } catch (e) {
      AppLogger.e('Error checking KYC status', e);
      return false;
    }
  }

  Future<bool> updateKYCStatus(String userId, String status) async {
    try {
      await prefs.setString('kyc_status_$userId', status);
      AppLogger.i('KYC status updated to $status for user $userId');
      return true;
    } catch (e) {
      AppLogger.e('Error updating KYC status', e);
      return false;
    }
  }

  Future<bool> deleteKYCData(String userId) async {
    try {
      await secureStorage.delete(key: 'kyc_data_$userId');
      await prefs.remove('kyc_status_$userId');
      await prefs.remove('kyc_completed_at_$userId');
      AppLogger.i('KYC data deleted for user $userId');
      return true;
    } catch (e) {
      AppLogger.e('Error deleting KYC data', e);
      return false;
    }
  }
}
