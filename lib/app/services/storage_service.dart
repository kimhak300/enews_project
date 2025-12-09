import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();

  late final GetStorage _box;

  @override
  void onInit() {
    super.onInit();
    _box = GetStorage();
  }

  // Read data
  T? read<T>(String key) {
    return _box.read<T>(key);
  }

  // Write data
  Future<void> write(String key, dynamic value) async {
    await _box.write(key, value);
  }

  // Remove data
  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  // Alias for remove (for compatibility with app_drawer_widget)
  Future<void> removeData(String key) async {
    await remove(key);
  }

  // Check if key exists
  bool hasData(String key) {
    return _box.hasData(key);
  }

  // Clear all data
  Future<void> clearAll() async {
    await _box.erase();
  }

  // Get all keys
  List<String> getKeys() {
    return _box.getKeys().cast<String>().toList();
  }
}
