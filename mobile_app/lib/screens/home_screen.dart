import 'package:flutter/material.dart';
import 'package:mobile_app/utils/constants.dart';
import 'package:mobile_app/widgets/bottom_nav.dart';
import 'package:mobile_app/screens/qr_scan_screen.dart';
import 'package:mobile_app/screens/wallet_screen.dart';
import 'package:mobile_app/screens/ride_history_screen.dart';
import 'package:mobile_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:mobile_app/providers/home_provider.dart';
import 'package:mobile_app/models/bicycle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final home = Provider.of<HomeProvider>(context, listen: false);

    // Run init only ONCE due to flag inside provider
    Future.microtask(() => home.init(auth));
  }

  Future<void> _onRefresh() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final home = Provider.of<HomeProvider>(context, listen: false);

    await home.refreshLocation();
    await home.refreshHomeData(auth);
  }

  void _navigateTo(String screen) {
    Widget? dest;
    switch (screen) {
      case 'qr-scan': dest = const QRScanScreen(); break;
      case 'wallet': dest = const WalletScreen(); break;
      case 'history': dest = const RideHistoryScreen(); break;
      case 'profile': dest = const ProfileScreen(); break;
    }
    if (dest != null) Navigator.push(context, MaterialPageRoute(builder: (_) => dest!));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, home, child) {
        final auth = Provider.of<AuthProvider>(context, listen: false);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(home, auth),
                  _welcomeBanner(),
                  _quickStats(home),
                  _scanButton(),
                  _nearbyBicycles(home),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNav(
            currentScreen: 'home',
            onNavigate: _navigateTo,
          ),
        );
      },
    );
  }

  // ---------- UI BUILDERS ----------

  Widget _header(HomeProvider home, AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Current Location", style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.location_on_rounded, size: 18, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(home.isLocating ? "Detecting..." : (home.currentLocality ?? "Unknown"),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _onRefresh,
                  child: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.primary),
                )
              ]),
            ]),
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.accent,
              child: Text(
                (auth.displayName?.isNotEmpty ?? false)
                    ? auth.displayName![0].toUpperCase()
                    : "?",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _welcomeBanner() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Welcome Back", style: TextStyle(color: Colors.white70)),
            SizedBox(height: 4),
            Text("Ready to ride?",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          ]),
          Icon(Icons.directions_bike_rounded, size: 38, color: Colors.white),
        ]),
      ),
    );
  }

  Widget _quickStats(HomeProvider home) {
    final time = _fmt(home.totalRideTimeThisMonth);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        Expanded(child: _stat("Total Rides", "${home.totalRidesThisMonth}", Icons.show_chart_rounded)),
        const SizedBox(width: 12),
        Expanded(child: _stat("Ride Time", time, Icons.schedule_rounded)),
      ]),
    );
  }

  Widget _stat(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primaryLight, AppColors.accentLight]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: [
        Icon(icon, size: 22, color: AppColors.primaryDark),
        const SizedBox(height: 6),
        Text(title, style: TextStyle(fontSize: 12, color: AppColors.primaryDark)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
      ]),
    );
  }

  Widget _scanButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: () => _navigateTo("qr-scan"),
        icon: const Icon(Icons.qr_code_scanner_rounded),
        label: const Text("Scan QR to Unlock", style: TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
      ),
    );
  }

  Widget _nearbyBicycles(HomeProvider home) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Nearby Bicycles", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(onPressed: _onRefresh, child: const Text("Refresh")),
        ]),
        const SizedBox(height: 12),
        if (home.isLoadingData) const Center(child: CircularProgressIndicator()),
        if (!home.isLoadingData && home.nearby.isEmpty)
          const Text("No bicycles found here.", style: TextStyle(color: AppColors.textSecondary)),
        ...home.nearby.map(_bikeTile),
      ]),
    );
  }

  Widget _bikeTile(Bicycle b) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("${b.model}${b.color != null ? " (${b.color})" : ""}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.location_on_rounded, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(b.locality ?? '-'),
          ])
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(b.status, style: TextStyle(color: b.status == "available" ? Colors.green : Colors.grey)),
          const SizedBox(height: 4),
          Text(b.assetCode ?? "", style: const TextStyle(color: AppColors.textSecondary)),
        ]),
      ]),
    );
  }

  String _fmt(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }
}
