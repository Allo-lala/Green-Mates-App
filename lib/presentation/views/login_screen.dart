// ignore_for_file: deprecated_member_use, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../services/metamask_service.dart';
import '../../widgets/app_button.dart';
import 'home_screen.dart';
import 'kyc_screen.dart';

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
    try {
      final authService = await ref.read(authServiceProvider.future);
      final installed = await authService.isMetaMaskInstalled();
      setState(() => _isMetaMaskInstalled = installed);
    } catch (_) {
      setState(() => _isMetaMaskInstalled = false);
    }
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
              FadeInDown(
                duration: const Duration(milliseconds: 800),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.eco, size: 80, color: AppColors.primary),
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
                  'Engage ○ Empower ● Earn',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              _buildFeature(Icons.account_balance_wallet,
                  'Secure Wallet Connection', 'Connect with MetaMask securely'),
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
                      border: Border.all(color: AppColors.error, width: 1.5),
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
                    onPressed: _isLoading ? null : _connectMetaMask,
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
                        : Image.asset(
                            'assets/images/metamask_logo.png',
                            height: 28,
                            width: 28,
                            fit: BoxFit.contain,
                          ),
                    label: Text(
                      _isLoading ? 'Connecting...' : 'Connect with MetaMask',
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
                duration: const Duration(milliseconds: 1150),
                delay: const Duration(milliseconds: 550),
                child: OutlinedButton.icon(
                  onPressed: _showMoreOptions,
                  icon: const Icon(Icons.add),
                  label: const Text('Create or Import Account'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primary, width: 2),
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
              if (!_isMetaMaskInstalled) ...[
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _showMetaMaskInstallGuide,
                  icon: const Icon(Icons.download),
                  label: const Text('Install MetaMask'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(
                      color: Color(0xFFF6851B),
                      width: 2,
                    ),
                    foregroundColor: const Color(0xFFF6851B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'By connecting, you agree to our Terms of Service\nand Privacy Policy',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
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

  Future<void> _connectMetaMask() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success =
          await ref.read(currentUserProvider.notifier).connectWallet();

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const KYCScreen(),
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Failed to connect wallet. Please check that MetaMask is installed and try again.';
        });
      }
    } on Exception catch (e) {
      setState(() {
        _errorMessage = _parseErrorMessage(e.toString());
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMoreOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect Your Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download_for_offline),
              title: const Text('Import Existing Wallet'),
              subtitle: const Text('Add a wallet using seed phrase'),
              onTap: () {
                Navigator.pop(context);
                _showImportWalletDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle),
              title: const Text('Create New Wallet'),
              subtitle: const Text('Generate a new wallet'),
              onTap: () {
                Navigator.pop(context);
                _showCreateWalletDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showImportWalletDialog() {
    final seedController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: seedController,
              decoration: const InputDecoration(
                labelText: 'Seed Phrase',
                hintText: 'Enter your 12 or 24 word seed phrase',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wallet import feature coming soon'),
                  backgroundColor: AppColors.warning,
                ),
              );
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showCreateWalletDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Wallet'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
                'A new wallet will be created and secured locally on your device.'),
            SizedBox(height: 16),
            Text('Make sure to back up your seed phrase safely!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Wallet creation feature coming soon'),
                  backgroundColor: AppColors.warning,
                ),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  String _parseErrorMessage(String error) {
    if (error.contains('MetaMask is not installed')) {
      return 'MetaMask is not installed. Please install it to continue.';
    } else if (error.contains('timeout') || error.contains('Timeout')) {
      return 'Connection timed out. Please ensure MetaMask is open and try again.';
    } else if (error.contains('User rejected')) {
      return 'You rejected the connection. Please try again.';
    } else if (error.contains('already in progress')) {
      return 'A connection is already in progress. Please wait.';
    } else if (error.contains('URI')) {
      return 'Failed to generate connection link. Please try again.';
    } else {
      return 'Connection error: Please try again or check your internet connection.';
    }
  }

  void _continueWithoutAccount() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _showMetaMaskInstallGuide() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Install MetaMask'),
        content: const Text(
          'MetaMask is not installed. Download it from the App Store (iOS) or Google Play (Android) to get started.',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
