import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RideHistoryItem {
  final String id;
  final String from;
  final String to;
  final int durationMinutes;
  final double fare;
  final DateTime date;
  final double distanceKm;

  RideHistoryItem({
    required this.id,
    required this.from,
    required this.to,
    required this.durationMinutes,
    required this.fare,
    required this.date,
    required this.distanceKm,
  });

  factory RideHistoryItem.fromJson(Map<String, dynamic> json) {
    return RideHistoryItem(
      id: json['id'] ?? '',
      from: json['from'] ?? '-',
      to: json['to'] ?? '-',
      durationMinutes: json['durationMinutes'] ?? 0,
      fare: double.tryParse(json['fare'].toString()) ?? 0.0,
      date: DateTime.parse(json['date']),
      distanceKm: double.tryParse(json['distanceKm'].toString()) ?? 0.0,
    );
  }

  String get formattedDuration {
    final m = durationMinutes % 60;
    final h = durationMinutes ~/ 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';
}

class RideProvider with ChangeNotifier {
  List<RideHistoryItem> allRides = [];

  bool isInitialized = false;
  bool isLoading = false;

  late final String backendBaseUrl;

  RideProvider() {
    backendBaseUrl = "${dotenv.env['BACKEND_URI']}";
  }

  Future<void> refreshRides(AuthProvider auth) async {
    if (auth.userId == null) return;
    final uid = auth.userId!;

    isLoading = true;
    notifyListeners();

    try {
      final res = await http.get(
        Uri.parse("$backendBaseUrl/rides/history?userId=$uid"),
      );

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        allRides = list.map((j) => RideHistoryItem.fromJson(j)).toList();
      }
    } catch (_) {
      allRides = [];
    }

    isLoading = false;
    isInitialized = true;
    notifyListeners();
  }

  /// FRONTEND FILTERING — no API calls
  List<RideHistoryItem> filtered(String filter) {
    final now = DateTime.now();

    if (filter == 'month') {
      return allRides.where((r) =>
        r.date.year == now.year && r.date.month == now.month).toList();
    }

    if (filter == 'year') {
      return allRides.where((r) =>
        r.date.year == now.year).toList();
    }

    return allRides; // all
  }
}
