// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'profile_screen.dart';

// Additional screens
import 'services_screen.dart';
import 'campaigns_screen.dart';
import 'wallet_screen.dart';
import 'events_screen.dart';
import 'eco_points_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: user?.profileImage != null
                ? CircleAvatar(
                    radius: 16,
                    backgroundImage: NetworkImage(user!.profileImage!),
                  )
                : const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Services'),
          BottomNavigationBarItem(
              icon: Icon(Icons.volunteer_activism), label: 'Go Green'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
        ],
      ),
    );
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHome();
      case 1:
        return const ServicesScreen();
      case 2:
        return const CampaignsScreen();
      case 3:
        return const EventsScreen();
      case 4:
        return const EcoPointsScreen();
      case 5:
        return const WalletScreen();
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0077B5),
                          Color(0xFF005983)
                        ], // LinkedIn blue tones
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Welcome back!',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              SizedBox(height: 10),
                              Text('Let\'s make a difference today',
                                  style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                        Icon(Icons.eco, size: 56, color: Colors.white),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Balance Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0077B5), Color(0xFF005983)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Your Balance',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: _balanceItem('CELO', '0.00')),
                            const SizedBox(width: 20),
                            Expanded(child: _balanceItem('cUSD', '0.00')),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Green Points Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C853), Color(0xFF00A94F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars, color: Colors.white, size: 48),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Green Points',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              SizedBox(height: 4),
                              Text('Total: 55',
                                  style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() => _selectedIndex = 4);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF00A94F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            elevation: 4,
                          ),
                          child: const Text('View'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Quick Actions card
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _quickAction(Icons.send, 'Send'),
                        _quickAction(Icons.download, 'Receive'),
                        _quickAction(Icons.event, 'Tickets'),
                        _quickAction(Icons.favorite, 'Donate'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _balanceItem(String symbol, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(amount,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(symbol,
              style: const TextStyle(fontSize: 15, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _quickAction(IconData icon, String label) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            if (label == 'Send' || label == 'Receive') {
              _showWalletActionSheet(label);
            } else if (label == 'Donate') {
              _showDonateSheet();
            } else if (label == 'Tickets') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventsScreen(),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FA),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ],
    );
  }

  void _showWalletActionSheet(String action) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$action Funds',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: action == 'Send'
                    ? 'Recipient Address'
                    : 'Your Wallet Address',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$action initiated successfully!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(action),
            ),
          ],
        ),
      ),
    );
  }

  void _showDonateSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose Payment Option',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('Use Green Points'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Donating with Green Points...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet, color: AppColors.primary),
              title: const Text('Use Wallet'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Donating via Wallet...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
