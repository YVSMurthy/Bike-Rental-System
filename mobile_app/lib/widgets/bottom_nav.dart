// lib/widgets/bottom_nav.dart

import 'package:flutter/material.dart';
import 'package:mobile_app/utils/constants.dart';

class BottomNav extends StatelessWidget {
  final String currentScreen;
  final Function(String) onNavigate;

  const BottomNav({
    super.key,
    required this.currentScreen,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      BottomNavItem(
        id: 'home',
        label: 'Home',
        icon: AppIcons.home,
        screen: 'home',
      ),
      BottomNavItem(
        id: 'scan',
        label: 'Scan',
        icon: AppIcons.scan,
        screen: 'qr-scan',
      ),
      BottomNavItem(
        id: 'wallet',
        label: 'Wallet',
        icon: AppIcons.wallet,
        screen: 'wallet',
      ),
      BottomNavItem(
        id: 'history',
        label: 'History',
        icon: AppIcons.history,
        screen: 'history',
      ),
      BottomNavItem(
        id: 'profile',
        label: 'Profile',
        icon: AppIcons.profile,
        screen: 'profile',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((item) {
              final isActive = currentScreen == item.screen;
              return _buildNavItem(item, isActive);
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BottomNavItem item, bool isActive) {
    return InkWell(
      onTap: () => onNavigate(item.screen),
      borderRadius: BorderRadius.circular(AppSizes.radiusMD),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              item.icon,
              size: AppSizes.iconMD,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem {
  final String id;
  final String label;
  final IconData icon;
  final String screen;

  BottomNavItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.screen,
  });
}