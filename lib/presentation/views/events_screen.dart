import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(text: 'Upcoming Events'),
                Tab(text: 'My Tickets'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildUpcomingEvents(context),
                _buildMyTickets(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEvents(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildEventCard(
          context,
          'Global Climate Summit 2025',
          DateTime(2025, 11, 15, 9, 0),
          'Nairobi, Kenya',
          '15.00 cUSD',
          150,
          500,
          350,
          false,
          Icons.campaign,
        ),
        const SizedBox(height: 12),
        _buildEventCard(
          context,
          'Tree Planting Marathon',
          DateTime(2025, 10, 28, 7, 0),
          'Kampala, Uganda',
          '5.00 cUSD',
          50,
          1000,
          234,
          false,
          Icons.park,
        ),
        const SizedBox(height: 12),
        _buildEventCard(
          context,
          'Sustainability Workshop',
          DateTime(2025, 10, 20, 14, 0),
          'Online Event',
          '10.00 cUSD',
          100,
          200,
          187,
          true,
          Icons.school,
        ),
        const SizedBox(height: 12),
        _buildEventCard(
          context,
          'Eco-Innovation Hackathon',
          DateTime(2025, 11, 5, 10, 0),
          'Lagos, Nigeria',
          '20.00 cUSD',
          200,
          300,
          89,
          false,
          Icons.code,
        ),
        const SizedBox(height: 12),
        _buildEventCard(
          context,
          'Renewable Energy Expo',
          DateTime(2025, 11, 10, 9, 0),
          'Accra, Ghana',
          '12.00 cUSD',
          120,
          800,
          456,
          false,
          Icons.solar_power,
        ),
      ],
    );
  }

  Widget _buildEventCard(
    BuildContext context,
    String title,
    DateTime dateTime,
    String location,
    String price,
    int points,
    int totalTickets,
    int soldTickets,
    bool isOnline,
    IconData icon,
  ) {
    final available = totalTickets - soldTickets;
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showEventDetails(
          context,
          title,
          dateTime,
          location,
          price,
          points,
          available,
          isOnline,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    // ignore: deprecated_member_use
                    AppColors.primary.withOpacity(0.3),
                    // ignore: deprecated_member_use
                    AppColors.accent.withOpacity(0.3),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(icon,
                        // ignore: deprecated_member_use
                        size: 80,
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.5)),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('MMM').format(dateTime).toUpperCase(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Text(
                            DateFormat('dd').format(dateTime),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isOnline)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.videocam, size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'ONLINE',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        dateFormat.format(dateTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        isOnline ? Icons.videocam : Icons.location_on,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
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
                      Text(
                        '$available tickets left',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyTickets(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTicketCard(
          context,
          'Sustainability Workshop',
          DateTime(2025, 10, 20, 14, 0),
          'Online Event',
          'TICKET-2025-001',
          'Active',
        ),
        const SizedBox(height: 12),
        _buildTicketCard(
          context,
          'Tree Planting Marathon',
          DateTime(2025, 10, 28, 7, 0),
          'Kampala, Uganda',
          'TICKET-2025-002',
          'Active',
        ),
        const SizedBox(height: 12),
        _buildTicketCard(
          context,
          'Climate Change Conference',
          DateTime(2025, 9, 15, 9, 0),
          'Nairobi, Kenya',
          'TICKET-2025-003',
          'Used',
        ),
      ],
    );
  }

  Widget _buildTicketCard(
    BuildContext context,
    String title,
    DateTime dateTime,
    String location,
    String ticketNumber,
    String status,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');
    final isActive = status == 'Active';

    return Card(
      child: InkWell(
        onTap: () => _showTicketDetails(
            context, title, dateTime, location, ticketNumber, status),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          // ignore: deprecated_member_use
                          ? AppColors.success.withOpacity(0.1)
                          // ignore: deprecated_member_use
                          : AppColors.textSecondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 10,
                        color: isActive
                            ? AppColors.success
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(
                    dateFormat.format(dateTime),
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary),
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
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.qr_code_2,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    ticketNumber,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDetails(
    BuildContext context,
    String title,
    DateTime dateTime,
    String location,
    String price,
    int points,
    int available,
    bool isOnline,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _detailRow(Icons.access_time,
                DateFormat('MMM dd, yyyy • HH:mm').format(dateTime)),
            const SizedBox(height: 8),
            _detailRow(isOnline ? Icons.videocam : Icons.location_on, location),
            const SizedBox(height: 8),
            _detailRow(
                Icons.confirmation_number, '$available tickets available'),
            const SizedBox(height: 24),
            const Text(
              'About this event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Join us for this amazing eco-friendly event. Learn, connect, and make a difference in the fight against climate change. This event brings together experts, activists, and community members.',
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ticket Price',
                          style: TextStyle(fontSize: 12)),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Eco Points', style: TextStyle(fontSize: 12)),
                      Row(
                        children: [
                          const Icon(Icons.stars,
                              size: 16, color: AppColors.accent),
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
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showTicketPurchaseConfirmation(context, title);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Purchase Ticket'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style:
                const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  void _showTicketPurchaseConfirmation(
      BuildContext context, String eventTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Purchase Confirmed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64, color: AppColors.success),
            const SizedBox(height: 16),
            Text(
              'Your ticket for $eventTitle has been purchased successfully!',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Icon(Icons.qr_code_2, size: 100),
                  SizedBox(height: 8),
                  Text('TICKET-2025-NEW',
                      style: TextStyle(fontFamily: 'monospace')),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('View Ticket'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showTicketDetails(
    BuildContext context,
    String title,
    DateTime dateTime,
    String location,
    String ticketNumber,
    String status,
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
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider, width: 2),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.qr_code_2, size: 150),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ticketNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _detailRow(Icons.access_time,
                      DateFormat('MMM dd, yyyy • HH:mm').format(dateTime)),
                  const SizedBox(height: 8),
                  _detailRow(Icons.location_on, location),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (status == 'Active')
              ElevatedButton(
                onPressed: () {},
                child: const Text('Add to Calendar'),
              ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
