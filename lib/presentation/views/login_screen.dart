// ignore_for_file: deprecated_member_use, unused_import, use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/metamask_service.dart';
import 'home_screen.dart';
import 'kyc_screen.dart';
import 'wallet_choice_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  FadeInDown(
                    duration: const Duration(milliseconds: 800),
                    child: Center(
                      child: Icon(
                        Icons.eco,
                        size: 140, // increased size
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  FadeInUp(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      'Grin Mates',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeInUp(
                    duration: const Duration(milliseconds: 900),
                    delay: const Duration(milliseconds: 100),
                    child: Text(
                      'Engage • Empower • Earn',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildFeature(
                      Icons.account_balance_wallet,
                      'Secure Wallet Connection',
                      'Connect with your favorite crypto wallets '),
                  const SizedBox(height: 16),
                  _buildFeature(Icons.payment, 'Crypto Payments',
                      'Pay with crypto instantly and securely'),
                  const SizedBox(height: 16),
                  _buildFeature(Icons.stars, 'Earn Green-Points',
                      'Get rewards for every eco-friendly action'),
                  const SizedBox(height: 48),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border:
                              Border.all(color: AppColors.error, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                color: AppColors.error, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _errorMessage!,
                                style: GoogleFonts.inter(
                                  color: AppColors.error,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1100),
                    delay: const Duration(milliseconds: 500),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _selectWallet,
                        icon: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Icon(Icons.account_balance_wallet),
                        label: Text(
                          _isLoading ? 'Connecting...' : 'Connect Your Wallet',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeInUp(
                    duration: const Duration(milliseconds: 1200),
                    delay: const Duration(milliseconds: 600),
                    child: TextButton(
                      onPressed: _continueWithoutAccount,
                      child: Text(
                        'Continue without an account',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Text(
                    'By connecting, you agree to our Terms of Service\nand Privacy Policy',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String description) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Row(
        children: [
          Icon(icon, size: 26, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectWallet() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WalletChoiceScreen()),
    );
  }

  Future<void> _connectMetaMask() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final metamask = MetaMaskService();
      await metamask.initialize();

      final address = await metamask.connectWallet(context: context);

      if (!mounted) return;

      if (address != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const KYCScreen()),
        );
      } else {
        setState(() {
          _errorMessage =
              'Failed to connect wallet. Please ensure MetaMask is installed and try again.';
        });
      }
    } on ConnectionException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            'Connection error: Please try again or check your internet connection.';
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _continueWithoutAccount() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }
}
