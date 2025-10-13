import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CampaignsScreen extends StatelessWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Eco Campaigns',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Support environmental projects worldwide',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        _buildCampaignCard(
          context,
          'Plant 1 Million Trees',
          'Kenya Reforestation Project',
          '50,000 cUSD',
          '38,500 cUSD',
          77,
          145,
          true,
        ),
        const SizedBox(height: 12),
        _buildCampaignCard(
          context,
          'Ocean Cleanup Initiative',
          'Pacific Ocean Plastic Removal',
          '75,000 cUSD',
          '45,200 cUSD',
          60,
          89,
          true,
        ),
        const SizedBox(height: 12),
        _buildCampaignCard(
          context,
          'Solar Schools Project',
          'Bringing solar power to rural schools',
          '30,000 cUSD',
          '28,750 cUSD',
          95,
          23,
          false,
        ),
        const SizedBox(height: 12),
        _buildCampaignCard(
          context,
          'Urban Garden Network',
          'Community gardens in city centers',
          '20,000 cUSD',
          '12,400 cUSD',
          62,
          67,
          true,
        ),
      ],
    );
  }

  Widget _buildCampaignCard(
    BuildContext context,
    String title,
    String location,
    String target,
    String raised,
    int progress,
    int daysLeft,
    bool isVerified,
  ) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showCampaignDetails(
            context, title, location, target, raised, progress),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              // ignore: deprecated_member_use
              color: AppColors.primary.withOpacity(0.2),
              child: Center(
                child: Icon(
                  Icons.eco,
                  size: 80,
                  // ignore: deprecated_member_use
                  color: AppColors.primary.withOpacity(0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isVerified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.success,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified,
                                  size: 12, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress / 100,
                      minHeight: 8,
                      backgroundColor: AppColors.divider,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$progress% funded',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '$daysLeft days left',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$raised raised of $target',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCampaignDetails(
    BuildContext context,
    String title,
    String location,
    String target,
    String raised,
    int progress,
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
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Progress: $progress%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress / 100,
                minHeight: 10,
                backgroundColor: AppColors.divider,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '$raised raised of $target goal',
              style:
                  const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            const Text('Donation Amount:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _donationButton(context, '5 cUSD')),
                const SizedBox(width: 8),
                Expanded(child: _donationButton(context, '10 cUSD')),
                const SizedBox(width: 8),
                Expanded(child: _donationButton(context, '25 cUSD')),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thank you for your donation!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Donate Custom Amount'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _donationButton(BuildContext context, String amount) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Donated $amount successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.primary, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
