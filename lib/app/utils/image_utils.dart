import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:newshub/app/config/api_constants.dart';

/// Resolve a possibly-local or remote image path into an [ImageProvider].
///
/// Supports:
/// - data URI (base64) strings -> [MemoryImage]
/// - file:// or raw local file paths -> [FileImage] (if file exists)
/// - relative storage paths like `/storage/avatars/x.png` -> full HTTP URL using [ApiConstants.mediaBaseUrl]
/// - absolute http(s) URLs -> [NetworkImage]
ImageProvider? resolveImageProvider(String? src) {
  if (src == null || src.isEmpty) return null;

  // Base64 data URI
  if (src.startsWith('data:image')) {
    try {
      final parts = src.split(',');
      final bytes = base64Decode(parts.last);
      return MemoryImage(bytes);
    } catch (e) {
      return null;
    }
  }

  var candidate = src;

  // Normalize file:// or file:/// prefixes
  if (candidate.startsWith('file://')) {
    candidate = candidate.replaceFirst(RegExp(r'^file:///*'), '/');
  }

  // Try local file (useful for picked images saved on device)
  try {
    final file = File(candidate);
    if (file.existsSync()) return FileImage(file);
  } catch (_) {}

  // Treat as network/relative path
  var url = candidate;
  if (!url.startsWith('http://') && !url.startsWith('https://')) {
    url = '${ApiConstants.mediaBaseUrl}${candidate.startsWith('/') ? candidate : '/$candidate'}';
  }

  return NetworkImage(url);
}
