import 'package:newshub/app/config/api_constants.dart';

/// Normalize a raw video source string into a playable URI string.
///
/// Rules:
/// - If the input starts with `file://` it is returned as-is (file URI).
/// - If it starts with `http://` or `https://` it is returned as-is.
/// - If it looks like a relative storage path (e.g. `/storage/...` or `storage/...`)
///   then the `ApiConstants.mediaBaseUrl` is prepended and returned as an HTTP URL.
/// - For other inputs without a scheme, the media base URL is prepended as a fallback.
String normalizeVideoSource(String raw) {
  final input = raw.trim();
  if (input.isEmpty || input == 'null') return '';

  final lower = input.toLowerCase();

  if (lower.startsWith('file://')) {
    // keep file URIs as-is
    return input;
  }

  if (lower.startsWith('http://') || lower.startsWith('https://')) {
    return input;
  }

  // Common relative storage/media paths - map to full HTTP URL
  if (lower.startsWith('/storage/') || lower.startsWith('storage/') ||
      lower.startsWith('/media_assets/') || lower.startsWith('media_assets/')) {
    return '${ApiConstants.mediaBaseUrl}${input.startsWith('/') ? input : '/$input'}';
  }

  // Fallback — treat as relative path and prepend base URL
  return '${ApiConstants.mediaBaseUrl}${input.startsWith('/') ? input : '/$input'}';
}

/// Helper to detect whether a normalized source is a file URI.
bool isFileUri(String normalized) {
  return normalized.startsWith('file://');
}
