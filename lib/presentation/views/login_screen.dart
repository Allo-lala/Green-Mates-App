// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'home_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isMetaMaskInstalled = true;

  @override
  void initState() {
    super.initState();
    _checkMetaMask();
  }

  Future<void> _checkMetaMask() async {
    final authService = await ref.read(authServiceProvider.future);
    final installed = await authService.isMetaMaskInstalled();
    setState(() => _isMetaMaskInstalled = installed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // App Logo
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.eco, size: 80, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              FadeInUp(
                duration: const Duration(milliseconds: 800),
                child: const Text(
                  'Grin Mates',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              FadeInUp(
                duration: const Duration(milliseconds: 900),
                delay: const Duration(milliseconds: 100),
                child: const Text(
                  'Engage ○ Empower ● Earn',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Features
              _buildFeature(Icons.account_balance_wallet,
                  'Secure Wallet Connection', 'Connect with MetaMask securely'),
              const SizedBox(height: 16),
              _buildFeature(Icons.payment, 'Crypto Payments',
                  'Pay with crypto instantly and securely'),
              const SizedBox(height: 16),
              _buildFeature(Icons.stars, 'Earn Green-Points',
                  'Get rewards for every eco-friendly action'),
              const SizedBox(height: 48),

              // Error Message
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.error),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: AppColors.error, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // --- MetaMask Button (White Style) ---
              FadeInUp(
                duration: const Duration(milliseconds: 1100),
                delay: const Duration(milliseconds: 500),
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _connectMetaMask,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : Image.asset(
                          'assets/images/metamask_logo.png',
                          height: 28,
                          width: 28,
                          fit: BoxFit.contain,
                        ),
                  label: Text(
                    _isLoading ? 'Connecting...' : 'Connect with MetaMask',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    elevation: 3,
                    shadowColor: Colors.grey.withOpacity(0.3),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- Continue Without Account ---
              FadeInUp(
                duration: const Duration(milliseconds: 1200),
                delay: const Duration(milliseconds: 600),
                child: TextButton(
                  onPressed: _continueWithoutAccount,
                  child: const Text(
                    'Continue without an account',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),

              if (!_isMetaMaskInstalled) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _installMetaMask,
                  icon: const Icon(Icons.download),
                  label: const Text('Install MetaMask'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(
                      color: Color(0xFFF6851B),
                      width: 2,
                    ),
                    foregroundColor: const Color(0xFFF6851B),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              Text(
                'By connecting, you agree to our Terms of Service\nand Privacy Policy',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String title, String description) {
    return FadeInUp(
      duration: const Duration(milliseconds: 1000),
      child: Row(
        children: [
          // 🔹 Clean icon — no background or shadow
          Icon(icon, size: 26, color: AppColors.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
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

  Future<void> _connectMetaMask() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    Future.microtask(() async {
      try {
        final success =
            await ref.read(currentUserProvider.notifier).connectWallet();

        if (!mounted) return;

        if (success) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
        } else {
          setState(() {
            _errorMessage = 'Failed to connect wallet. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Connection error: $e';
        });
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    });
  }

  void _continueWithoutAccount() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _installMetaMask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Install MetaMask'),
        content: const Text(
            'MetaMask is not installed. Would you like to install it from the app store?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Install'),
          ),
        ],
      ),
    );
  }
}
