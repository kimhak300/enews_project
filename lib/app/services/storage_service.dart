import 'package:get_storage/get_storage.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  // Save data
  Future<void> saveData(String key, dynamic value) async {
    await _storage.write(key, value);
  }

  // Read data
  T? readData<T>(String key) {
    return _storage.read<T>(key);
  }

  // Remove data
  Future<void> removeData(String key) async {
    await _storage.remove(key);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _storage.erase();
  }

  // Check if key exists
  bool hasData(String key) {
    return _storage.hasData(key);
  }

  // Alias methods for convenience
  void write(String key, dynamic value) => _storage.write(key, value);
  T? read<T>(String key) => _storage.read<T>(key);
  void remove(String key) => _storage.remove(key);
}
