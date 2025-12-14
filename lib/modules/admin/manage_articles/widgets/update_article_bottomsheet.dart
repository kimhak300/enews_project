import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newshub/api/controller/article_controller.dart';
import 'package:newshub/api/controller/category_controller.dart';

class UpdateArticleBottomsheet extends StatefulWidget {

  final Map<String, dynamic> article;

  const UpdateArticleBottomsheet({super.key, required this.article});

  @override
  State<UpdateArticleBottomsheet> createState() =>
      _UpdateArticleBottomsheetState();
}

class _UpdateArticleBottomsheetState extends State<UpdateArticleBottomsheet> {
  final _formKey = GlobalKey<FormState>();
  final ArticleController articleController = Get.find();
  final CategoryController categoryController = Get.find();

  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController excerptController;
  late TextEditingController contentController;

  String selectedStatus = 'draft';
  bool isFeatured = false;

  List<String> selectedCategories = [];
  List<String> selectedTags = [];
  List<String> mediaBase64 = [];
  List<File> pickedFiles = [];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    subtitleController = TextEditingController();
    excerptController = TextEditingController();
    contentController = TextEditingController();

    categoryController.fetchCategories();

    // Prefill fields from article
    final a = widget.article;
    titleController.text = a['title'] ?? '';
    subtitleController.text = a['subtitle'] ?? '';
    excerptController.text = a['excerpt'] ?? '';
    contentController.text = a['content_html'] ?? '';
    selectedStatus = a['status'] ?? 'draft';
    isFeatured = a['is_featured'] ?? false;
    selectedCategories = List<String>.from(a['categories'] ?? []);
    selectedTags = List<String>.from(a['tags'] ?? []);
    mediaBase64 = List<String>.from(a['media'] ?? []);
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage(imageQuality: 80);
    if (images != null) {
      pickedFiles = images.map((e) => File(e.path)).toList();
      mediaBase64 = pickedFiles.map((file) {
        final bytes = file.readAsBytesSync();
        return 'data:image/${file.path.split('.').last};base64,${base64Encode(bytes)}';
      }).toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update Article',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Title
              TextFormField(
                controller: titleController,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.colorScheme.primary)),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Subtitle
              TextFormField(
                controller: subtitleController,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Subtitle',
                  labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
                ),
              ),
              const SizedBox(height: 12),

              // Excerpt
              TextFormField(
                controller: excerptController,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Excerpt',
                  labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
                ),
              ),
              const SizedBox(height: 12),

              // Content
              TextFormField(
                controller: contentController,
                maxLines: 5,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                decoration: InputDecoration(
                  labelText: 'Content HTML',
                  labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Status
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceVariant,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
                ),
                items: ['draft', 'published', 'archived']
                    .map((s) => DropdownMenuItem(
                  value: s,
                  child: Text(s.toUpperCase(), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
                ))
                    .toList(),
                onChanged: (v) => setState(() => selectedStatus = v!),
              ),
              const SizedBox(height: 12),

              // Featured
              Row(
                children: [
                  Checkbox(
                    value: isFeatured,
                    onChanged: (v) => setState(() => isFeatured = v!),
                    fillColor: MaterialStateProperty.all(theme.colorScheme.primary),
                  ),
                  Text('Featured Article', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
                ],
              ),
              const SizedBox(height: 12),

              // Categories
              Obx(() {
                if (categoryController.isLoading.value) {
                  return CircularProgressIndicator(color: theme.colorScheme.primary);
                }
                return DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Category',
                    labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.85)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.18))),
                  ),
                  items: categoryController.categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.name,
                          child: Text(c.name, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95))),
                        ),
                  )
                      .toList(),
                  onChanged: (v) {
                    if (v != null && !selectedCategories.contains(v)) {
                      setState(() => selectedCategories.add(v));
                    }
                  },
                );
              }),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: selectedCategories
                    .map(
                      (c) => Chip(
                    label: Text(c, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onPrimary)),
                    backgroundColor: theme.colorScheme.primary,
                    onDeleted: () => setState(() => selectedCategories.remove(c)),
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 12),

              // Media Picker
              ElevatedButton.icon(
                onPressed: pickImages,
                icon: Icon(Icons.image, color: theme.colorScheme.onPrimary),
                label: Text('Pick Images', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary)),
                style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                children: pickedFiles
                    .map(
                      (file) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      file,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateArticle,
                  style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                  child: Text('Update', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary)),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }

  void _updateArticle() async {
    if (!_formKey.currentState!.validate()) return;

    final body = {
      'title': titleController.text,
      'subtitle': subtitleController.text,
      'excerpt': excerptController.text,
      'content_html': contentController.text,
      'status': selectedStatus,
      'is_featured': isFeatured,
      'categories': selectedCategories,
      'tags': selectedTags,
      'media': mediaBase64,
      // author_id is not changeable during update for security
      'language_code': 'en',
    };

    final id = widget.article['id'];
    
    try {
      await articleController.updateArticle(id, body);
      
      if (mounted) {
        Get.snackbar(
          'Success',
          'Article updated successfully',
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          snackPosition: SnackPosition.TOP,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to update article: ${e.toString()}',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }
}