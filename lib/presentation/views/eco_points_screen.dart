import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class EcoPointsScreen extends StatelessWidget {
  const EcoPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' '),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showPointsInfo(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPointsOverview(),
          const SizedBox(height: 20),
          _buildStatsCards(),
          const SizedBox(height: 24),
          Row(
            children: [
              const Text(
                'Points History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showLeaderboard(context),
                child: const Text('Leaderboard →'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPointsHistory(),
        ],
      ),
    );
  }

  // ---- OVERVIEW -----------------
  Widget _buildPointsOverview() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, Color(0xFF5DADE2)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.stars, size: 32, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'Total Green Points',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '2,450',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPointsStat('Available', '1,850', Icons.check_circle),
              Container(width: 1, height: 40, color: Colors.white30),
              _buildPointsStat('Donated', '400', Icons.favorite),
              Container(width: 1, height: 40, color: Colors.white30),
              _buildPointsStat('Redeemed', '200', Icons.redeem),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPointsStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.white70),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  // ================== STATS CARDS ==================
  Widget _buildStatsCards() {
    return Row(
      children: [
        Expanded(
          child: Card(
            // ignore: deprecated_member_use
            color: AppColors.success.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  Icon(Icons.trending_up, size: 32, color: AppColors.success),
                  SizedBox(height: 8),
                  Text(
                    '15',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ),
                  Text(
                    'This Month',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  Icon(Icons.emoji_events, size: 32, color: AppColors.warning),
                  SizedBox(height: 8),
                  Text(
                    '#12',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                  Text(
                    'Your Rank',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================== HISTORY ==================
  Widget _buildPointsHistory() {
    return Column(
      children: [
        _buildHistoryItem(
            'Service Payment',
            'Electric Bike Rental',
            '+55',
            DateTime.now().subtract(const Duration(hours: 2)),
            Icons.electric_bike,
            AppColors.success),
        _buildHistoryItem(
            'Campaign Donation',
            'Tree Planting Project',
            '-100',
            DateTime.now().subtract(const Duration(hours: 5)),
            Icons.favorite,
            AppColors.error),
        _buildHistoryItem(
            'Event Ticket',
            'Sustainability Workshop',
            '+100',
            DateTime.now().subtract(const Duration(days: 1)),
            Icons.event,
            AppColors.success),
        _buildHistoryItem(
            'Service Payment',
            'Cooking Gas Refill',
            '+250',
            DateTime.now().subtract(const Duration(days: 2)),
            Icons.local_fire_department,
            AppColors.success),
        _buildHistoryItem(
            'Points Redeemed',
            'Event Discount Voucher',
            '-200',
            DateTime.now().subtract(const Duration(days: 3)),
            Icons.redeem,
            AppColors.error),
        _buildHistoryItem(
            'Service Payment',
            'Solar Panel Installation',
            '+5000',
            DateTime.now().subtract(const Duration(days: 7)),
            Icons.solar_power,
            AppColors.success),
      ],
    );
  }

  Widget _buildHistoryItem(
    String type,
    String description,
    String points,
    DateTime timestamp,
    IconData icon,
    Color color,
  ) {
    final isPositive = points.startsWith('+');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(type, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description, style: const TextStyle(fontSize: 12)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars,
                    size: 16,
                    color: isPositive ? AppColors.success : AppColors.error),
                const SizedBox(width: 4),
                Text(
                  points,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isPositive ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            Text(
              _formatTimestamp(timestamp),
              style:
                  const TextStyle(fontSize: 10, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // ================== INFO DIALOG ==================
  void _showPointsInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Eco Points'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('How to Earn Points:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),
              Text('• Pay for eco-friendly services.'),
              Text('• Donate to environmental campaigns.'),
              Text('• Participate in sustainability events.'),
              SizedBox(height: 16),
              Text('How to Redeem Points:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),
              Text('• Redeem points for discounts on services.'),
              Text('• Use points for event tickets and vouchers.'),
              Text('• Exchange points for eco-friendly products.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // ================== LEADERBOARD DIALOG ==================
  void _showLeaderboard(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leaderboard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(
              leading: CircleAvatar(child: Text('1')),
              title: Text('Jane Doe'),
              trailing: Text('12,300 pts'),
            ),
            ListTile(
              leading: CircleAvatar(child: Text('2')),
              title: Text('John Smith'),
              trailing: Text('11,200 pts'),
            ),
            ListTile(
              leading: CircleAvatar(child: Text('3')),
              title: Text('Amina K.'),
              trailing: Text('10,850 pts'),
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                  backgroundColor: AppColors.primary, child: Text('12')),
              title: Text('You'),
              trailing: Text('2,450 pts'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
