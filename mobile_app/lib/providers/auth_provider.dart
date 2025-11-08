import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _email;
  String? _displayName;

  String? get userId => _userId;
  String? get email => _email;
  String? get displayName => _displayName;

  void setUser({
    required String userId,
    required String email,
    required String displayName
  }) {
    _userId = userId;
    _email = email;
    _displayName = displayName;
    notifyListeners();
  }

  void logout() {
    _userId = null;
    _email = null;
    _displayName = null;
    notifyListeners();
  }
}
