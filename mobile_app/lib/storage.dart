import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  late final FlutterSecureStorage _storage;

  Storage() {
    _storage = FlutterSecureStorage();
  }

  Future<void> set(String key, String text) async {
    await _storage.write(key: key, value: text);
  }

  Future<String?> get(String key) async {
    return (await _storage.read(key: key));
  }

  Future<void> clear() async {
    await _storage.deleteAll();
  }
}