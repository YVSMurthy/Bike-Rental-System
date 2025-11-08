// lib/screens/ride_history_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_app/utils/constants.dart';
import 'package:mobile_app/widgets/bottom_nav.dart';
import 'package:mobile_app/screens/home_screen.dart';
import 'package:mobile_app/screens/qr_scan_screen.dart';
import 'package:mobile_app/screens/wallet_screen.dart';
import 'package:mobile_app/screens/profile_screen.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  String selectedFilter = 'all';
  
  final List<RideHistory> rides = [
    RideHistory(
      id: '1',
      from: 'Downtown Station',
      to: 'Central Park',
      duration: '23m',
      fare: 5.50,
      date: DateTime.now(),
      distance: '2.3 km',
    ),
    RideHistory(
      id: '2',
      from: 'Central Park',
      to: 'Downtown Station',
      duration: '18m',
      fare: 3.25,
      date: DateTime.now().subtract(const Duration(days: 1)),
      distance: '1.8 km',
    ),
    RideHistory(
      id: '3',
      from: 'Tech Hub',
      to: 'Airport',
      duration: '45m',
      fare: 12.75,
      date: DateTime.now().subtract(const Duration(days: 2)),
      distance: '5.2 km',
    ),
    RideHistory(
      id: '4',
      from: 'Downtown Station',
      to: 'Beach',
      duration: '32m',
      fare: 8.50,
      date: DateTime.now().subtract(const Duration(days: 3)),
      distance: '3.1 km',
    ),
  ];

  void _navigateToScreen(String screen) {
    Widget? destination;
    
    switch (screen) {
      case 'home':
        destination = const HomeScreen();
        break;
      case 'qr-scan':
        destination = const QRScanScreen();
        break;
      case 'wallet':
        destination = const WalletScreen();
        break;
      case 'history':
        return; // Already on history
      case 'profile':
        destination = const ProfileScreen();
        break;
    }
    
    if (destination != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(AppStrings.rideHistory),
      ),
      body: Column(
        children: [
          // Filter Tabs
          _buildFilterTabs(),
          
          // Rides List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                ...rides.map((ride) => _buildRideCard(ride)),
                const SizedBox(height: 80), // Space for bottom nav
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNav(
        currentScreen: 'history',
        onNavigate: _navigateToScreen,
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All Rides', 'all'),
            const SizedBox(width: 12),
            _buildFilterChip('This Month', 'month'),
            const SizedBox(width: 12),
            _buildFilterChip('This Year', 'year'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = selectedFilter == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildRideCard(RideHistory ride) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // From/To and Fare
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          AppIcons.location,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ride.from,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 24),
                      child: Text(
                        'to ${ride.to}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${ride.fare.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Divider
          const Divider(color: AppColors.border, height: 1),
          
          const SizedBox(height: 16),
          
          // Trip Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem(AppIcons.timer, ride.duration),
              _buildDetailItem(AppIcons.navigation, ride.distance),
              _buildDetailItem(AppIcons.calendar, _formatDate(ride.date)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class RideHistory {
  final String id;
  final String from;
  final String to;
  final String duration;
  final double fare;
  final DateTime date;
  final String distance;

  RideHistory({
    required this.id,
    required this.from,
    required this.to,
    required this.duration,
    required this.fare,
    required this.date,
    required this.distance,
  });
}