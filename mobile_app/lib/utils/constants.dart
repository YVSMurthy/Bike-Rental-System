// lib/utils/constants.dart

import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF10B981); // Green
  static const Color primaryLight = Color(0xFFD1FAE5);
  static const Color primaryDark = Color(0xFF059669);

  // Accent Colors
  static const Color accent = Color(0xFF06B6D4); // Cyan
  static const Color accentLight = Color(0xFFCFFAFE);
  static const Color accentDark = Color(0xFF0891B2);

  // Background Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color backgroundSecondary = Color(0xFFFFFFFF);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);

  // Border Colors
  static const Color border = Color(0xFFE2E8F0);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}

class AppStrings {
  // Active Ride
  static const String activeRide = 'Active Ride';
  static const String rideInProgress = 'Ride in Progress';
  static const String duration = 'Duration';
  static const String currentFare = 'Current Fare';
  static const String endRide = 'End Ride';
  static const String safetyMessage = 'Stay on designated bike paths for safety';
  
  // Ride Summary
  static const String rideComplete = 'Ride Complete';
  static const String greatRide = 'Great Ride!';
  static const String rideCompletedSuccess = 'Your ride has been completed successfully';
  static const String distance = 'Distance';
  static const String fare = 'Fare';
  static const String from = 'From';
  static const String to = 'To';
  static const String bikeId = 'Bike ID';
  static const String download = 'Download';
  static const String share = 'Share';
  static const String backToHome = 'Back to Home';
  
  // Wallet
  static const String wallet = 'Wallet';
  static const String availableBalance = 'Available Balance';
  static const String addMoney = 'Add Money';
  static const String cards = 'Cards';
  static const String pendingDue = 'Pending Due';
  static const String recentTransactions = 'Recent Transactions';
  
  // History
  static const String rideHistory = 'Ride History';
  static const String allRides = 'All Rides';
  
  // Profile
  static const String profile = 'Profile';
  static const String memberSince = 'Member since';
  static const String email = 'Email';
  static const String phone = 'Phone';
  static const String address = 'Address';
  static const String settings = 'Settings';
  static const String accountSettings = 'Account Settings';
  static const String privacySecurity = 'Privacy & Security';
  static const String logout = 'Logout';
}

class AppIcons {
  // Navigation
  static const IconData home = Icons.home;
  static const IconData scan = Icons.qr_code_scanner;
  static const IconData wallet = Icons.account_balance_wallet;
  static const IconData history = Icons.history;
  static const IconData profile = Icons.person;
  
  // Common
  static const IconData bike = Icons.pedal_bike;
  static const IconData location = Icons.location_on;
  static const IconData navigation = Icons.navigation;
  static const IconData timer = Icons.timer;
  static const IconData money = Icons.attach_money;
  static const IconData back = Icons.arrow_back;
  static const IconData qrCode = Icons.qr_code;
  
  // Actions
  static const IconData download = Icons.download;
  static const IconData share = Icons.share;
  static const IconData settingsIcon = Icons.settings;
  static const IconData logoutIcon = Icons.logout;
  static const IconData add = Icons.add;
  static const IconData creditCard = Icons.credit_card;
  
  // Status
  static const IconData success = Icons.check_circle;
  static const IconData warning = Icons.warning;
  static const IconData error = Icons.error;
  static const IconData info = Icons.info;
  
  // Auth
  static const IconData emailIcon = Icons.email;
  static const IconData lock = Icons.lock;
  static const IconData phoneIcon = Icons.phone;
  static const IconData eye = Icons.visibility;
  static const IconData eyeOff = Icons.visibility_off;
  
  // Others
  static const IconData trendingUp = Icons.trending_up;
  static const IconData clock = Icons.access_time;
  static const IconData calendar = Icons.calendar_today;
  static const IconData shield = Icons.shield;
  static const IconData zap = Icons.bolt;
}

class AppSizes {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;

  // Border Radius
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusFull = 999.0;

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 48.0;

  // Button Heights
  static const double buttonHeightSM = 40.0;
  static const double buttonHeightMD = 48.0;
  static const double buttonHeightLG = 56.0;
}

class AppDurations {
  static const Duration splashDelay = Duration(seconds: 3);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
}