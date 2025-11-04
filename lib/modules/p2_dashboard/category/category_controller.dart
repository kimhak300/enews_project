import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CategoryModel {
  final String id;
  final String name;
  final String tag; // e.g., Technology, Environment
  final String description;
  final String author;
  final String date; // simple yyyy-MM-dd
  final int views;
  final int items; // how many articles in this category (display only)
  final int colorValue; // ARGB color int
  final String? mediaPath; // path to image or video file
  final String? mediaType; // 'image' or 'video'

  CategoryModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.description,
    required this.author,
    required this.date,
    required this.views,
    required this.items,
    required this.colorValue,
    this.mediaPath,
    this.mediaType,
  });

  factory CategoryModel.newItem({
    required String name,
    required String tag,
    required String description,
    required Color color,
    String? mediaPath,
    String? mediaType,
  }) {
    final now = DateTime.now();
    final id = now.millisecondsSinceEpoch.toString();
    return CategoryModel(
      id: id,
      name: name,
      tag: tag,
      description: description,
      author: 'admin'.tr,
      date: '${now.year.toString().padLeft(4, '0')}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
      views: 0,
      items: 0,
      colorValue: color.value,
      mediaPath: mediaPath,
      mediaType: mediaType,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name'.tr: name,
        'tag'.tr: tag,
        'description'.tr: description,
        'author': author,
        'date'.tr: date,
        'views'.tr: views,
        'items': items,
        'colorValue': colorValue,
        'mediaPath'.tr: mediaPath,
        'mediaType'.tr: mediaType,
      };

  static CategoryModel fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        tag: json['tag'] as String,
        description: json['description'] as String,
        author: json['author'] as String,
        date: json['date'] as String,
        views: (json['views'] ?? 0) as int,
        items: (json['items'] ?? 0) as int,
        colorValue: (json['colorValue'] ?? Colors.blue.value) as int,
        mediaPath: json['mediaPath'] as String?,
        mediaType: json['mediaType'] as String?,
      );
}

class CategoryController extends GetxController {
  static const _storageKey = 'dashboard_categories';
  final _box = GetStorage();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    final raw = _box.read(_storageKey);
    if (raw is String && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
      categories.assignAll(list);
    } else if (raw is List) {
      final list = raw
          .map((e) => CategoryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      categories.assignAll(list);
    } else {
      // Seed with a couple sample rows for first run
      categories.assignAll([
        CategoryModel.newItem(
          name: 'Breaking: Tech Innovation Summit 2025',
          tag: 'Technology',
          description:
              'Major tech companies announce groundbreaking AI developments...',
          color: Colors.blue,
        ),
        CategoryModel.newItem(
          name: 'Global Climate Conference Results',
          tag: 'Environment',
          description:
              'World leaders reach consensus on new climate initiatives...',
          color: Colors.green,
        ),
      ]);
      _persist();
    }
  }

  Future<void> _persist() async {
    final data = categories.map((e) => e.toJson()).toList();
    await _box.write(_storageKey, jsonEncode(data));
  }

  Future<void> create({
    required String name,
    required String tag,
    required String description,
    required Color color,
    String? mediaPath,
    String? mediaType,
  }) async {
    categories.insert(0, CategoryModel.newItem(
      name: name,
      tag: tag,
      description: description,
      color: color,
      mediaPath: mediaPath,
      mediaType: mediaType,
    ));
    await _persist();
  }

  Future<void> updateCategory(CategoryModel item, {
    required String name,
    required String tag,
    required String description,
    required Color color,
    String? mediaPath,
    String? mediaType,
  }) async {
    final idx = categories.indexWhere((e) => e.id == item.id);
    if (idx >= 0) {
      categories[idx] = CategoryModel(
        id: item.id,
        name: name,
        tag: tag,
        description: description,
        author: item.author,
        date: item.date,
        views: item.views,
        items: item.items,
        colorValue: color.value,
        mediaPath: mediaPath,
        mediaType: mediaType,
      );
      await _persist();
    }
  }

  Future<void> remove(CategoryModel item) async {
    categories.removeWhere((e) => e.id == item.id);
    await _persist();
  }
}
