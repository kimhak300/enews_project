import 'storage_service.dart';

class CacheManager {
  final StorageService _storage = StorageService();
  
  // Cache with expiry
  Future<void> cacheData(
    String key,
    dynamic data, {
    Duration? expiry,
  }) async {
    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
      'expiry': expiry?.inSeconds,
    };
    await _storage.write(key, cacheData);
  }

  // Get cached data if not expired
  T? getCachedData<T>(String key) {
    final cacheData = _storage.read<Map<String, dynamic>>(key);
    
    if (cacheData == null) return null;
    
    final timestamp = DateTime.parse(cacheData['timestamp'] as String);
    final expiry = cacheData['expiry'] as int?;
    
    if (expiry != null) {
      final expiryTime = timestamp.add(Duration(seconds: expiry));
      if (DateTime.now().isAfter(expiryTime)) {
        _storage.remove(key);
        return null;
      }
    }
    
    return cacheData['data'] as T?;
  }

  // Clear expired cache
  Future<void> clearExpiredCache() async {
    final keys = _storage.getKeys();
    for (final key in keys) {
      final cacheData = _storage.read<Map<String, dynamic>>(key);
      if (cacheData != null && cacheData.containsKey('timestamp')) {
        final timestamp = DateTime.parse(cacheData['timestamp'] as String);
        final expiry = cacheData['expiry'] as int?;
        
        if (expiry != null) {
          final expiryTime = timestamp.add(Duration(seconds: expiry));
          if (DateTime.now().isAfter(expiryTime)) {
            await _storage.remove(key);
          }
        }
      }
    }
  }

  // Clear all cache
  Future<void> clearAllCache() async {
    await _storage.clear();
  }
}
