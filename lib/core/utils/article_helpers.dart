import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Helper class for article-related utilities
class ArticleHelpers {
  /// Format a date to a human-readable relative time
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 365) {
      return '${(diff.inDays / 365).floor()}y ago';
    } else if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else if (diff.inDays > 0) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Get the display label for a user role
  static String getRoleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return 'official_account'.tr.toUpperCase();
      case 'organizer':
      case 'organization':
        return 'news_organizer'.tr.toUpperCase();
      default:
        return 'user'.tr.toUpperCase();
    }
  }

  /// Get the badge background color for a user role
  static Color getRoleBadgeColor(String role, BuildContext context) {
    final theme = Theme.of(context);
    switch (role.toLowerCase()) {
      case 'admin':
        return theme.colorScheme.primary;
      case 'organizer':
      case 'organization':
        return theme.colorScheme.surfaceVariant;
      default:
        return theme.colorScheme.error;
    }
  }

  /// Get the badge text color for a user role
  static Color getRoleBadgeTextColor(String role, BuildContext context) {
    final theme = Theme.of(context);
    switch (role.toLowerCase()) {
      case 'admin':
        return theme.colorScheme.onPrimary;
      case 'organizer':
      case 'organization':
        return theme.colorScheme.onSurfaceVariant;
      default:
        return theme.colorScheme.onError;
    }
  }

  /// Build an image widget from a URL or base64 string
  static Widget buildImage(
    String? src, {
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
  }) {
    if (src == null || src.isEmpty) {
      return placeholder ?? const SizedBox();
    }

    if (src.startsWith('data:image')) {
      try {
        final bytes = base64Decode(src.split(',').last);
        return Image.memory(
          bytes,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (_, __, ___) => placeholder ?? const SizedBox(),
        );
      } catch (_) {
        return placeholder ?? const SizedBox();
      }
    }

    return Image.network(
      src,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => placeholder ?? const SizedBox(),
    );
  }

  /// Get the icon for an article type
  static IconData getArticleIcon(String? type) {
    switch (type) {
      case 'video':
        return Icons.play_circle_outline;
      case 'news_feed':
        return Icons.newspaper;
      case 'article':
      default:
        return Icons.article_outlined;
    }
  }

  /// Get a category color based on index
  static Color getCategoryColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[index % colors.length];
  }
}
