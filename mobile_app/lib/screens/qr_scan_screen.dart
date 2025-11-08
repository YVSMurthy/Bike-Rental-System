// lib/screens/qr_scan_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_app/utils/constants.dart';
import 'package:mobile_app/screens/active_ride_screen.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleScan() {
    final rideData = RideData(
      bikeId: 'BIKE-001',
      station: 'Downtown Station',
      startTime: DateTime.now(),
    );
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveRideScreen(rideData: rideData),
      ),
    );
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
        title: const Text('Scan QR Code'),
      ),
      body: Column(
        children: [
          // QR Scanner Area
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated QR Frame
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Scanning Line Animation
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Positioned(
                                top: _animation.value * 240,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withOpacity(0),
                                        AppColors.primary,
                                        AppColors.primary.withOpacity(0),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          // QR Icon
                          Center(
                            child: Icon(
                              AppIcons.qrCode,
                              size: 120,
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                          // Corner Decorations
                          ..._buildCorners(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Instruction Text
                    const Text(
                      'Position the QR code on the bike\nwithin the frame',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Buttons
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Simulate Scan Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _handleScan,
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                      ),
                      child: const Text(
                        'Simulate Scan',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    const cornerSize = 20.0;
    const cornerThickness = 4.0;
    const offset = 20.0;

    return [
      // Top Left
      Positioned(
        top: offset,
        left: offset,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primary, width: cornerThickness),
              left: BorderSide(color: AppColors.primary, width: cornerThickness),
            ),
          ),
        ),
      ),
      // Top Right
      Positioned(
        top: offset,
        right: offset,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.primary, width: cornerThickness),
              right: BorderSide(color: AppColors.primary, width: cornerThickness),
            ),
          ),
        ),
      ),
      // Bottom Left
      Positioned(
        bottom: offset,
        left: offset,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primary, width: cornerThickness),
              left: BorderSide(color: AppColors.primary, width: cornerThickness),
            ),
          ),
        ),
      ),
      // Bottom Right
      Positioned(
        bottom: offset,
        right: offset,
        child: Container(
          width: cornerSize,
          height: cornerSize,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.primary, width: cornerThickness),
              right: BorderSide(color: AppColors.primary, width: cornerThickness),
            ),
          ),
        ),
      ),
    ];
  }
}

class RideData {
  final String bikeId;
  final String station;
  final DateTime startTime;

  RideData({
    required this.bikeId,
    required this.station,
    required this.startTime,
  });
}