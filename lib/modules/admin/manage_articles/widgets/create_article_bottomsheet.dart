import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newshub/api/controller/article_controller.dart';
import 'package:newshub/api/controller/category_controller.dart' as api_cat;
import 'package:newshub/api/service/article_service.dart';
import 'package:newshub/modules/auth/services/auth_service.dart';

class CreateArticleBottomsheet extends StatefulWidget {
  final Map<String, dynamic>? article; // if null => create, else update

  const CreateArticleBottomsheet({super.key, this.article});

  @override
  State<CreateArticleBottomsheet> createState() => _CreateArticleBottomsheetState();
}

class _CreateArticleBottomsheetState extends State<CreateArticleBottomsheet> {
  final _formKey = GlobalKey<FormState>();
  final ArticleController articleController = Get.find();
  final api_cat.CategoryController categoryController = Get.find();

  late TextEditingController titleController;
  late TextEditingController subtitleController;
  late TextEditingController excerptController;
  late TextEditingController contentController;

  String selectedStatus = 'draft';
  String selectedType = 'article';
  bool isFeatured = false;

  List<String> selectedCategories = [];
  List<String> selectedTags = [];

  List<String> mediaBase64 = [];
  List<File> pickedFiles = [];
  File? pickedVideo;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    subtitleController = TextEditingController();
    excerptController = TextEditingController();
    contentController = TextEditingController();

    categoryController.fetchCategories();

    if (widget.article != null) {
      final a = widget.article!;
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
  }

  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage(imageQuality: 80);
    if (images != null && images.isNotEmpty) {
      pickedFiles = images.map((e) => File(e.path)).toList();
      mediaBase64 = pickedFiles.map((file) {
        final bytes = file.readAsBytesSync();
        return 'data:image/${file.path.split('.').last};base64,${base64Encode(bytes)}';
      }).toList();
      setState(() {});
    }
  }

  Future<void> pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      pickedVideo = File(video.path);
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
                      widget.article != null ? 'Update Article' : 'Create Article',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.95),
                        fontWeight: FontWeight.w600,
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
                    labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.primary)),
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
                    labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.primary)),
                  ),
                ),
                const SizedBox(height: 12),

                // Excerpt
                TextFormField(
                  controller: excerptController,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Excerpt',
                    labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.primary)),
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
                    labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.primary)),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),

                // Status
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
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

                // Type
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: InputDecoration(
                    labelText: 'Type',
                    labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  ),
                  items: ['article', 'video', 'news_feed']
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.toUpperCase(), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => selectedType = v ?? 'article'),
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
                    Text('Featured Article', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.85))),
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
                      labelStyle: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                    ),
                    items: categoryController.categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat.name,
                            child: Text(cat.name, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
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

                if (selectedType != 'video') ...[
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
                        .map((file) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                file,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                ]

                else ...[
                  ElevatedButton.icon(
                    onPressed: pickVideo,
                    icon: Icon(Icons.video_library, color: theme.colorScheme.onPrimary),
                    label: Text('Pick Video', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimary)),
                    style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                  ),
                  const SizedBox(height: 6),
                  if (pickedVideo != null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Selected: ${pickedVideo!.path.split('/').last}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.85)),
                      ),
                    ),
                  if (pickedVideo == null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select one video file (mp4/mov/avi, up to ~200 MB).',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveArticle,
                    style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                    child: Text(widget.article != null ? 'Update' : 'Create', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveArticle() async {
    if (!_formKey.currentState!.validate()) return;

    // Ensure AuthService is registered (defensive in case initial binding didn't run)
    final authService = Get.isRegistered<AuthService>()
        ? Get.find<AuthService>()
        : Get.put(AuthService(), permanent: true);
    final currentUser = await authService.getSavedUser();

    if (currentUser == null) {
      Get.snackbar(
        'Authentication Required',
        'Please login first to create articles',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Double check token exists
    final hasToken = await authService.hasToken();
    if (!hasToken) {
      Get.snackbar(
        'Authentication Required',
        'Your session has expired. Please login again',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    List<String> mediaPayload = mediaBase64;
    if (selectedType == 'video') {
      if (pickedVideo == null) {
        Get.snackbar('Error', 'Please pick a video', backgroundColor: Get.theme.colorScheme.error, colorText: Get.theme.colorScheme.onError);
        return;
      }

      try {
        final service = ArticleService();
        final url = await service.uploadMedia(file: pickedVideo!, type: 'video');
        if (url.isEmpty) throw Exception('Video upload returned empty URL');
        mediaPayload = [url];
      } catch (e) {
        if (mounted) {
          Get.snackbar(
            'Error',
            'Failed to upload video: ${e.toString()}',
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 5),
          );
        }
        return;
      }
    }

    final body = {
      'title': titleController.text,
      'subtitle': subtitleController.text,
      'excerpt': excerptController.text,
      'content_html': contentController.text,
      'type': selectedType,
      'status': selectedStatus,
      'is_featured': isFeatured,
      'categories': selectedCategories,
      'tags': selectedTags,
      'media': mediaPayload,
      'author_id': currentUser.id.toString(),
      'language_code': 'en',
    };

    try {
      if (widget.article != null) {
        final id = widget.article!['id'];
        await articleController.updateArticle(id, body);
        if (mounted) {
          Get.snackbar(
            'Success',
            'Article updated successfully',
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        await articleController.createArticle(body);
        if (mounted) {
          Get.snackbar(
            'Success',
            'Article created successfully',
            backgroundColor: Get.theme.colorScheme.primary,
            colorText: Get.theme.colorScheme.onPrimary,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to save article: ${e.toString()}',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}