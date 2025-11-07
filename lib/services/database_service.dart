// PostgreSQL Database Service for production use
import 'package:postgres/postgres.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart';
import '../core/utils/logger.dart';

class DatabaseService {
  late Connection _connection;
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<void> initialize({
    required String host,
    required int port,
    required String database,
    required String username,
    required String password,
  }) async {
    try {
      _connection = await Connection.open(
        Endpoint(
          host: host,
          port: port,
          database: database,
          username: username,
          password: password,
        ),
      );
      AppLogger.i('PostgreSQL Database connected successfully');
    } catch (e) {
      AppLogger.e('Database connection failed', e);
      rethrow;
    }
  }

  // Create User
  Future<String?> createUser({
    required String walletAddress,
    String? email,
    String? fullName,
  }) async {
    try {
      final result = await _connection.execute(
        Sql.named(
          '''INSERT INTO users (wallet_address, email, full_name) 
             VALUES (@wallet_address, @email, @full_name) 
             RETURNING id''',
        ),
        parameters: {
          'wallet_address': walletAddress,
          'email': email,
          'full_name': fullName,
        },
      );

      if (result.isNotEmpty) {
        final userId = result.first[0] as String;
        AppLogger.i('User created: $userId');
        return userId;
      }
      return null;
    } catch (e) {
      AppLogger.e('Error creating user', e);
      return null;
    }
  }

  // Save KYC Data
  Future<bool> saveKYCData({
    required String userId,
    required Map<String, dynamic> kycData,
  }) async {
    try {
      await _connection.execute(
        Sql.named(
          '''INSERT INTO kyc_data (
               user_id, first_name, last_name, date_of_birth, nationality,
               identity_document_url, proof_of_address_url, selfie_url,
               address, city, postal_code, country, kyc_status
             ) VALUES (
               @user_id, @first_name, @last_name, @dob, @nationality,
               @id_doc, @proof_addr, @selfie, @address, @city, @postal, @country, 'pending'
             )''',
        ),
        parameters: {
          'user_id': userId,
          'first_name': kycData['firstName'],
          'last_name': kycData['lastName'],
          'dob': kycData['dateOfBirth'],
          'nationality': kycData['nationality'],
          'id_doc': kycData['identityDocumentUrl'],
          'proof_addr': kycData['proofOfAddressUrl'],
          'selfie': kycData['selfieUrl'],
          'address': kycData['address'],
          'city': kycData['city'],
          'postal': kycData['postalCode'],
          'country': kycData['country'],
        },
      );

      AppLogger.i('KYC data saved for user: $userId');
      return true;
    } catch (e) {
      AppLogger.e('Error saving KYC data', e);
      return false;
    }
  }

  // Get KYC Status
  Future<String?> getKYCStatus(String userId) async {
    try {
      final result = await _connection.execute(
        Sql.named('SELECT kyc_status FROM kyc_data WHERE user_id = @user_id'),
        parameters: {'user_id': userId},
      );

      if (result.isNotEmpty) {
        return result.first[0] as String;
      }
      return null;
    } catch (e) {
      AppLogger.e('Error getting KYC status', e);
      return null;
    }
  }

  // Update User Balance
  Future<bool> updateUserBalance({
    required String userId,
    required double celoBalance,
    required double cusdBalance,
    required int greenPoints,
  }) async {
    try {
      await _connection.execute(
        Sql.named(
          '''INSERT INTO balances (user_id, celo_balance, cusd_balance, green_points_balance)
             VALUES (@user_id, @celo, @cusd, @points)
             ON CONFLICT (user_id) DO UPDATE SET
             celo_balance = @celo, cusd_balance = @cusd, green_points_balance = @points,
             last_updated = CURRENT_TIMESTAMP''',
        ),
        parameters: {
          'user_id': userId,
          'celo': celoBalance,
          'cusd': cusdBalance,
          'points': greenPoints,
        },
      );

      return true;
    } catch (e) {
      AppLogger.e('Error updating user balance', e);
      return false;
    }
  }

  // Record Transaction
  Future<bool> recordTransaction({
    required String userId,
    required String transactionHash,
    required String type,
    required String tokenSymbol,
    required double amount,
  }) async {
    try {
      await _connection.execute(
        Sql.named(
          '''INSERT INTO transactions (user_id, transaction_hash, transaction_type, token_symbol, amount, status)
             VALUES (@user_id, @hash, @type, @token, @amount, 'completed')''',
        ),
        parameters: {
          'user_id': userId,
          'hash': transactionHash,
          'type': type,
          'token': tokenSymbol,
          'amount': amount,
        },
      );

      return true;
    } catch (e) {
      AppLogger.e('Error recording transaction', e);
      return false;
    }
  }

  Future<void> close() async {
    await _connection.close();
    AppLogger.i('Database connection closed');
  }
}
