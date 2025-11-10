// ignore_for_file: deprecated_member_use, use_build_context_synchronously, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:vibration/vibration.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/wallet_constants.dart';
import '../../services/metamask_service.dart';
import '../../services/rabby_service.dart';
import 'kyc_screen.dart';

class WalletChoiceScreen extends StatefulWidget {
  const WalletChoiceScreen({super.key});

  @override
  State<WalletChoiceScreen> createState() => _WalletChoiceScreenState();
}

class _WalletChoiceScreenState extends State<WalletChoiceScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  WalletType? _selectedWallet;

  @override
  Widget build(BuildContext context) {
    final supportedWallets = WalletConstants.getSupportedWallets();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Wallet',
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose a wallet to connect with Grin Mates',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              ...supportedWallets.asMap().entries.map((entry) {
                final index = entry.key;
                final wallet = entry.value;
                final isSelected = _selectedWallet == wallet.type;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: Duration(milliseconds: index * 100),
                    child: GestureDetector(
                      onTap:
                          _isLoading ? null : () => _selectWallet(wallet.type),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? wallet.primaryColor.withOpacity(0.1)
                              : AppColors.cardBackground,
                          border: Border.all(
                            color: isSelected
                                ? wallet.primaryColor
                                : AppColors.divider,
                            width: isSelected ? 2.5 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: wallet.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset(
                                wallet.logo,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.account_balance_wallet,
                                    color: wallet.primaryColor,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wallet.displayName,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    ' ',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: wallet.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 32),
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
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isLoading || _selectedWallet == null)
                      ? null
                      : _connectWallet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Connect Wallet',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _triggerHaptic() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 20);
      }
    } catch (_) {}
  }

  void _selectWallet(WalletType type) {
    _triggerHaptic();
    setState(() {
      _selectedWallet = type;
    });
  }

  Future<void> _connectWallet() async {
    if (_selectedWallet == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final walletInfo = WalletConstants.getWalletInfo(_selectedWallet!);

      switch (_selectedWallet) {
        case WalletType.metamask:
          final metamask = MetaMaskService();
          await metamask.initialize();

          final address = await metamask.connectWallet(context: context);

          if (!mounted) return;

          if (address != null) {
            _triggerHaptic();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const KYCScreen()),
            );
          } else {
            setState(() {
              _errorMessage =
                  'Failed to connect ${walletInfo?.displayName}. Please try again.';
            });
          }
          break;
        case WalletType.rabbyWallet:
          final rabby = RabbyService();
          await rabby.initialize();

          final address = await rabby.connectWallet(context: context);

          if (!mounted) return;

          if (address != null) {
            _triggerHaptic();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const KYCScreen()),
            );
          } else {
            setState(() {
              _errorMessage =
                  'Failed to connect ${walletInfo?.displayName}. Please try again.';
            });
          }
          break;
        default:
          // For other wallets, show a placeholder message
          setState(() {
            _errorMessage =
                '${walletInfo?.displayName} integration coming soon. Currently supporting MetaMask and Rabby.';
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
}
