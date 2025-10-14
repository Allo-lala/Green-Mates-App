import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

// Additional screens
import 'services_screen.dart';
import 'campaigns_screen.dart';
import 'wallet_screen.dart';
import 'events_screen.dart';
import 'eco_points_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go Green Mates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {},
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
              icon: Icon(Icons.volunteer_activism), label: 'Campaigns'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.stars), label: 'Points'),
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
                        colors: [AppColors.primary, AppColors.primaryDark],
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
                              Text('Let\'s make a difference today 🌿',
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
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Your Balance',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
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
                  ),

                  const SizedBox(height: 24),

                  // Eco Points Section
                  Card(
                    // ignore: deprecated_member_use
                    color: AppColors.accent.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      leading: const Icon(Icons.stars,
                          color: AppColors.accent, size: 40),
                      title: const Text(
                        'Eco Points',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: const Text('Total: 0 ⭐'),
                      trailing: TextButton(
                        onPressed: () {
                          setState(() => _selectedIndex = 4);
                        },
                        child: const Text('View'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Quick Actions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Expanded(child: _buildQuickActions()),
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
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(amount,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(symbol,
              style: const TextStyle(
                  fontSize: 15, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _quickAction(Icons.send, 'Send'),
        _quickAction(Icons.download, 'Receive'),
        _quickAction(Icons.event, 'Tickets'),
        _quickAction(Icons.favorite, 'Donate'),
      ],
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
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$label action coming soon!')),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  // 🌿 Wallet Action Bottom Sheet
  void _showWalletActionSheet(String action) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

  // 💚 Donate Sheet
  void _showDonateSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
              title: const Text('Use Eco Points'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Donating with Eco Points...')),
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
