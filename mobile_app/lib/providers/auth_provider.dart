import 'package:flutter/material.dart';
import 'package:mobile_app/storage.dart';

class AuthProvider with ChangeNotifier {
  String? _userId;
  String? _email;
  String? _phone;
  String? _displayName;
  bool _isInitialized = false;

  String? get userId => _userId;
  String? get email => _email;
  String? get phone => _phone;
  String? get displayName => _displayName;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final storage = Storage();
    _userId = await storage.get('user_id');
    _email = await storage.get('email');
    _phone = await storage.get('phone');
    _displayName = await storage.get('display_name');
    
    _isInitialized = true;
    notifyListeners();
    
    print('AuthProvider loaded from storage:');
    print('  userId: $_userId');
    print('  email: $_email');
    print('  phone: $_phone');
    print('  displayName: $_displayName');
  }

  Future<void> setUser({
    required String userId,
    required String email,
    required String phone,
    required String displayName
  }) async {
    _userId = userId;
    _email = email;
    _phone = phone;
    _displayName = displayName;
    
    // Save to storage
    final storage = Storage();
    await storage.set('user_id', userId);
    await storage.set('email', email);
    await storage.set('phone', phone);
    await storage.set('display_name', displayName);
    
    notifyListeners();
  }

  Future<void> logout() async {
    // Clear from storage
    final storage = Storage();
    await storage.clear();
    
    _userId = null;
    _email = null;
    _phone = null;
    _displayName = null;
    
    notifyListeners();
  }
}