import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  // Write data
  Future<void> write(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Read data
  T? read<T>(String key) {
    return _storage.read<T>(key);
  }

  // Remove data
  Future<void> remove(String key) async {
    await _storage.remove(key);
  }

  // Clear all data
  Future<void> clear() async {
    await _storage.erase();
  }

  // Check if key exists
  bool hasData(String key) {
    return _storage.hasData(key);
  }

  // Get all keys
  Iterable<String> getKeys() {
    return _storage.getKeys();
  }
}
