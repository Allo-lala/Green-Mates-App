import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          ' ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildServiceCard(
          context,
          'Electric Bike Rental',
          'Rent eco-friendly e-bikes for your daily commute',
          '5.50 cUSD/hour',
          Icons.electric_bike,
          55,
        ),
        const SizedBox(height: 12),
        _buildServiceCard(
          context,
          'Cooking Gas Refill',
          'Clean cooking gas delivery to your doorstep',
          '25.00 cUSD',
          Icons.local_fire_department,
          250,
        ),
        const SizedBox(height: 12),
        _buildServiceCard(
          context,
          'Solar Panel Installation',
          'Professional solar panel setup for your home',
          '500.00 cUSD',
          Icons.solar_power,
          5000,
        ),
        const SizedBox(height: 12),
        _buildServiceCard(
          context,
          'Eco Workshop Pass',
          'Access to sustainability workshops and training',
          '15.00 cUSD',
          Icons.school,
          150,
        ),
      ],
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    String price,
    IconData icon,
    int points,
  ) {
    return Card(
      child: InkWell(
        onTap: () =>
            _showServiceDetails(context, title, description, price, points),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.stars,
                            size: 14, color: AppColors.accent),
                        const SizedBox(width: 4),
                        Text(
                          '+$points pts',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showServiceDetails(
    BuildContext context,
    String title,
    String description,
    String price,
    int points,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style:
                  const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Price:', style: TextStyle(fontSize: 16)),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Eco Points:', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    const Icon(Icons.stars, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      '+$points',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order placed for $title!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Order Now'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
