import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageArticlesController extends GetxController {
  // Tabs
  final List<String> tabs = ['All', 'Draft', 'Published', 'Archived'];

  // Search controllers per tab
  final Map<String, TextEditingController> searchControllers = {};

  // Articles data
  final RxMap<String, List<Map<String, dynamic>>> tabArticles =
      <String, List<Map<String, dynamic>>>{
        'All': [
          {
            'title': 'Flutter State Management',
            'author': {'id': 1, 'display_name': 'John Doe'},
            'status': 'draft',
            'categories': ['Flutter', 'Programming'],
            'tags': ['GetX', 'State', 'UI'],
            'media_assets': ['image', 'video'],
          },
          {
            'title': 'Dart Null Safety',
            'author': {'id': 2, 'display_name': 'Jane Smith'},
            'status': 'published',
            'categories': ['Dart', 'Programming'],
            'tags': ['Null Safety', 'Tips'],
            'media_assets': ['image'],
          },
          {
            'title': 'UI Design Basics',
            'author': {'id': 3, 'display_name': 'Alice Johnson'},
            'status': 'archived',
            'categories': ['Design', 'UX'],
            'tags': ['UI', 'Colors', 'Typography'],
            'media_assets': ['video'],
          },
        ],
        'Draft': [],
        'Published': [],
        'Archived': [],
      }.obs;

  @override
  void onInit() {
    super.onInit();
    for (var tab in tabs) {
      searchControllers[tab] = TextEditingController();
    }
  }

  @override
  void onClose() {
    for (var c in searchControllers.values) {
      c.dispose();
    }
    super.onClose();
  }

  // Filter articles by tab and search query
  List<Map<String, dynamic>> filterArticles(String tab) {
    final query = searchControllers[tab]?.text.toLowerCase() ?? '';
    final list = tab == 'All'
        ? tabArticles['All']!
        : tabArticles['All']!
        .where((a) => a['status'].toString().toLowerCase() == tab.toLowerCase())
        .toList();

    if (query.isEmpty) return list;

    return list
        .where((a) =>
    a['title'].toString().toLowerCase().contains(query) ||
        a['author']['display_name'].toString().toLowerCase().contains(query))
        .toList();
  }

  // Status color
  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.orangeAccent;
      case 'published':
        return Colors.green;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.blueAccent;
    }
  }

  // Category color
  Color categoryColor(String category) => Colors.blueAccent.shade100;

  // Tag color
  Color tagColor(String tag) => Colors.orangeAccent.shade100;
}