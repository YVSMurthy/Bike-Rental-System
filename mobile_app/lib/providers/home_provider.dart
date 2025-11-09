import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_app/models/bicycle.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeProvider with ChangeNotifier {
  bool _initialized = false;
  String? currentLocality;
  bool isLocating = false;
  bool isLoadingData = false;

  int totalRidesThisMonth = 0;
  Duration totalRideTimeThisMonth = Duration.zero;

  List<Bicycle> nearby = [];

  late final String backendBaseUrl;

  HomeProvider() {
    backendBaseUrl = "${dotenv.env['BACKEND_URI']}";
  }

  /// Detect phone location ONE TIME when app opens or refreshes
  Future<void> refreshLocation() async {
    isLocating = true;
    notifyListeners();

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    try {
      final pos = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final pm = placemarks.isNotEmpty ? placemarks.first : null;

      if (pm?.subLocality?.isNotEmpty ?? false) {
        currentLocality = pm!.subLocality!;
      } else if (pm?.locality?.isNotEmpty ?? false) {
        currentLocality = pm!.locality!;
      } else {
        currentLocality = "Katpadi";
      }
    } catch (_) {
      currentLocality = "Katpadi";
    }

    isLocating = false;
    notifyListeners();
  }

  /// Fetch Ride Summary + Nearby Bicycle List
  Future<void> refreshHomeData(AuthProvider auth) async {
    if (auth.userId == null) return;
    final uid = auth.userId!;

    isLoadingData = true;
    notifyListeners();

    try {
      // Ride summary
      final res1 = await http.get(
        Uri.parse("$backendBaseUrl/rides/get-ride-summary?userId=$uid"),
      );

      if (res1.statusCode == 200) {
        final json = jsonDecode(res1.body);
        totalRidesThisMonth = json["totalRides"] ?? 0;
        totalRideTimeThisMonth = Duration(minutes: json["totalMinutes"] ?? 0);
      }

      // Nearby bicycles
      final res2 = await http.get(
        Uri.parse("$backendBaseUrl/bicycles/nearby?locality=${Uri.encodeComponent(currentLocality ?? "")}"),
      );

      if (res2.statusCode == 200) {
        final list = jsonDecode(res2.body) as List;
        nearby = list.map((b) => Bicycle(
          id: b["id"],
          model: b["model"],
          color: b["color"],
          assetCode: b["asset_code"],
          status: b["status"],
          locality: b["locality"],
        )).toList();
      } else {
        nearby = [];
      }
    } catch (_) {
      totalRidesThisMonth = 0;
      totalRideTimeThisMonth = Duration.zero;
      nearby = [];
    }

    isLoadingData = false;
    notifyListeners();
  }

  /// Run once when HomeScreen opens
  Future<void> init(AuthProvider auth) async {
    if (_initialized) return;
    
    await refreshLocation();
    await refreshHomeData(auth);
  }
}
