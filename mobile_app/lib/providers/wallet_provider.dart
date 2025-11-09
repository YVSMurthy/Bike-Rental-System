import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_app/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WalletTransaction {
  final String type;
  final String description;
  final double amount;
  final DateTime date;

  WalletTransaction({
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      type: json['type'] ?? 'payment',
      description: json['description'] ?? 'Transaction',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      date: DateTime.parse(json['created_at']),
    );
  }
}

class WalletProvider with ChangeNotifier {
  double balance = 0.0;
  List<WalletTransaction> transactions = [];

  bool isInitialized = false;
  bool isLoading = false;

  late final String backendBaseUrl;

  WalletProvider() {
    backendBaseUrl = "${dotenv.env['BACKEND_URI']}";
  }

  /// Refresh wallet. If `force = false`, do not refetch if we already have data.
  Future<void> refreshWallet(AuthProvider auth, {bool force = false}) async {
    if (auth.userId == null) return;
    final uid = auth.userId!;

    // ✅ Prevent useless refetching
    if (isInitialized && !force) {
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final res = await http.get(
        Uri.parse("$backendBaseUrl/wallet/get-wallet-summary?userId=$uid"),
      );

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);

        balance = (json["balance"] is int)
            ? (json["balance"] as int).toDouble()
            : (json["balance"] ?? 0.0).toDouble();

        transactions = (json["transactions"] as List)
            .map((t) => WalletTransaction.fromJson(t))
            .toList();
      }
    } catch (_) {
      // Keep previous cache instead of resetting
    }

    isLoading = false;
    isInitialized = true;
    notifyListeners();
  }
}
