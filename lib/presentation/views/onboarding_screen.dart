// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:vibration/vibration.dart';
import 'package:animate_do/animate_do.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/onboarding_page.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'Empower Your Impact',
      subtitle: 'Take Control',
      description:
          'Connect your wallet securely and take control of your digital assets. Experience true ownership with GrinMates.',
      imagePath: 'assets/images/onboarding.png',
      icon: Icons.account_balance_wallet,
    ),
    OnboardingPage(
      title: 'Engage & Earn',
      subtitle: 'Get Rewarded',
      description:
          'Participate in eco-friendly initiatives and earn Green Points. Every action counts towards a sustainable future.',
      imagePath: 'assets/images/eco.png',
      icon: Icons.trending_up,
    ),
    OnboardingPage(
      title: 'Join the Movement',
      subtitle: 'Make a Difference',
      description:
          'Be part of a global community fighting climate change. Together, we create real locked environmental impact.',
      imagePath: 'assets/images/lock.png',
      icon: Icons.eco,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _triggerHaptic() async {
    try {
      if (await Vibration.hasVibrator()) {
        await Vibration.vibrate(duration: 20);
      }
    } catch (_) {}
  }

  void _nextPage() {
    _triggerHaptic();
    if (_currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _skipOnboarding() {
    _triggerHaptic();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                  _triggerHaptic();
                },
                itemCount: pages.length,
                itemBuilder: (context, index) => OnboardingPageWidget(
                    page: pages[index],
                    pageIndex: index,
                    totalPages: pages.length),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: SmoothPageIndicator(
                controller: _pageController,
                count: pages.length,
                effect: WormEffect(
                  dotHeight: 10,
                  dotWidth: 10,
                  spacing: 8,
                  activeDotColor: AppColors.primary,
                  dotColor: AppColors.primary.withOpacity(0.3),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isLastPage ? 'Get Started' : 'Next',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (!isLastPage) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _skipOnboarding,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
