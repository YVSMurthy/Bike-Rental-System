import 'package:flutter/material.dart';
import 'package:mobile_app/utils/constants.dart';
import 'package:mobile_app/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/screens/bike_details_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Scanner controller (configure detection speed here)
  late final MobileScannerController _scannerController;

  bool _checkingWallet = false;
  bool _scanned = false; // prevent multiple triggers

  late final String backendBaseUrl;

  @override
  void initState() {
    super.initState();
    backendBaseUrl = "${dotenv.env['BACKEND_URI']}";

    _scannerController = MobileScannerController(
      // prevents duplicate callbacks
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
      formats: const [BarcodeFormat.qrCode], // optional: QR only
    );

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _checkWalletBeforeScan();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _checkWalletBeforeScan() async {
    setState(() => _checkingWallet = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final wallet = Provider.of<WalletProvider>(context, listen: false);

    if (!wallet.isInitialized) {
      await wallet.refreshWallet(auth);
    }

    setState(() => _checkingWallet = false);

    if (wallet.balance < 10) {
      _showLowBalanceDialog();
    }
  }

  void _onQRDetected(String code) async {
    if (_scanned) return;
    _scanned = true;

    final bike = await _fetchBikeDetails(code);
    if (bike == null) {
      _scanned = false;
      _showInvalidBikeDialog();
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DummyBikeDetailsScreen(bike: bike),
      ),
    );
  }

  Future<Map<String, dynamic>?> _fetchBikeDetails(String code) async {
    try {
      final uri = Uri.parse("$backendBaseUrl/bicycles/by-code?code=${Uri.encodeComponent(code)}");
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  void _showLowBalanceDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Low Wallet Balance"),
        content: const Text(
          "You need at least ₹10 in your wallet to start a ride.\n\nPlease top up and try again.",
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    ).then((_) {
      if (mounted) Navigator.pop(context);
    });
  }

  void _showInvalidBikeDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Invalid QR"),
        content: const Text("This QR code does not match any registered bicycle."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Retry")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(AppIcons.back), onPressed: () => Navigator.pop(context)),
        title: const Text('Scan QR Code'),
      ),
      body: Stack(
        children: [
          _buildScanner(),
          if (_checkingWallet)
            Container(color: Colors.black38, child: const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  Widget _buildScanner() {
    return Column(
      children: [
        // Top spacer
        const SizedBox(height: 40),
        
        // Instructions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.qr_code_scanner, color: AppColors.primary, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Position the QR code within the frame to scan',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Scanner - centered and fixed height
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
            height: MediaQuery.of(context).size.width * 0.8, // Square aspect ratio
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: MobileScanner(
                    controller: _scannerController,
                    onDetect: (capture) {
                      final barcode = capture.barcodes.firstOrNull;
                      final String? code = barcode?.rawValue;
                      if (code != null) _onQRDetected(code.trim());
                    },
                  ),
                ),
                _scannerOverlay(),
                // animated scan line
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (_, __) => Align(
                        alignment: Alignment(0, _animation.value * 2 - 1),
                        child: Container(
                          height: 2,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0),
                                AppColors.primary,
                                AppColors.primary.withOpacity(0),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.5),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Corner decorations
                _buildCornerDecorations(),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Additional info
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: const [
              Text(
                'Make sure the QR code is clearly visible',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'and well-lit for best results',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        
        const Spacer(),
      ],
    );
  }

  Widget _scannerOverlay() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 3),
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }

  Widget _buildCornerDecorations() {
    return Stack(
      children: [
        // Top-left corner
        Positioned(
          top: 12,
          left: 12,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 4),
                left: BorderSide(color: Colors.white, width: 4),
              ),
            ),
          ),
        ),
        // Top-right corner
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.white, width: 4),
                right: BorderSide(color: Colors.white, width: 4),
              ),
            ),
          ),
        ),
        // Bottom-left corner
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 4),
                left: BorderSide(color: Colors.white, width: 4),
              ),
            ),
          ),
        ),
        // Bottom-right corner
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.white, width: 4),
                right: BorderSide(color: Colors.white, width: 4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Tiny extension so we can safely grab firstOrNull
extension _FirstOrNull<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
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
