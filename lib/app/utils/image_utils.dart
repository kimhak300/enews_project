import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:newshub/app/constants/app_constant.dart';

/// Returns an [ImageProvider] for the given raw image string.
/// Supports:
/// - base64 data URIs (data:image/..;base64,....)
/// - local file paths (with or without `file://` scheme)
/// - http/https or relative storage paths (will be prefixed with STORAGE_BASE_URL)
ImageProvider? imageProviderFromString(String? raw) {
  if (raw == null || raw.isEmpty) return null;

  // Base64 data URI
  if (raw.startsWith('data:image')) {
    try {
      final bytes = base64Decode(raw.split(',').last);
      return MemoryImage(bytes);
    } catch (_) {
      return null;
    }
  }

  // Normalize file://
  String candidate = raw;
  if (candidate.startsWith('file://')) {
    candidate = candidate.replaceFirst('file://', '');
  }

  // Try local file
  try {
    final file = File(candidate);
    if (file.existsSync()) return FileImage(file);
  } catch (_) {
    // ignore
  }

  // Treat as network/relative path
  String url = candidate;
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = '${AppConstants.STORAGE_BASE_URL}${candidate.startsWith('/') ? candidate : '/$candidate'}';
  }

  return NetworkImage(url);
}
