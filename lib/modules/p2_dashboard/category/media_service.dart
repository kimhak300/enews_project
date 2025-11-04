import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

/// Service for handling media file operations
class MediaService {
  /// Copy a file to permanent storage
  static Future<String> saveMediaFile(String sourcePath, String mediaType) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(sourcePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final targetDir = path.join(appDir.path, '${mediaType}s');
    final targetPath = path.join(targetDir, '${timestamp}_$fileName');
    
    // Create directory if needed
    final directory = Directory(targetDir);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    
    // Copy file
    final sourceFile = File(sourcePath);
    final targetFile = await sourceFile.copy(targetPath);
    
    return targetFile.path;
  }

  /// Check if path is a temporary cache path
  static bool isCachePath(String filePath) {
    return filePath.contains('/cache/');
  }

  /// Migrate cached file to permanent storage
  static Future<String?> migrateCachedFile(String cachedPath, String mediaType) async {
    try {
      final sourceFile = File(cachedPath);
      if (!await sourceFile.exists()) {
        return null;
      }
      return await saveMediaFile(cachedPath, mediaType);
    } catch (e) {
      return null;
    }
  }
}
