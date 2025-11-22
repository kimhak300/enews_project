class AppConfig {
    // App Info
  static const String appName = 'eNews';
  static const String appVersion = '1.0.0';

  // API Endpoints
  // Updated for local Docker Laravel API mapped to host port 8000
  static const String apiBaseUrl = "http://10.0.2.2:8000/api";
  static const String fileBaseUrl = "http://10.0.2.2:8000/";
  // 🌐 For iOS Simulator (uncomment if needed)
  // static const String apiBaseUrl = "http://localhost:9055/api";
  // static const String fileBaseUrl = "http://localhost:9056/";
  
  // 🌐 For Physical Device (replace with your computer's IP)
  // static const String apiBaseUrl = "http://192.168.x.x:9055/api";
  // static const String fileBaseUrl = "http://192.168.x.x:9056/";
  
  /// Constructs full image URL from relative path
  /// Example: "static/pos/products/beverage/sting.png" → "http://10.0.2.2:9056/static/pos/products/beverage/sting.png"
  static String getImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    return '$fileBaseUrl$imagePath';
  }
}
