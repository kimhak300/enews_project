import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newshub/api/controller/article_controller.dart';
import 'package:newshub/api/controller/category_controller.dart' as api_cat;
import 'package:newshub/api/service/article_service.dart';
import 'package:newshub/modules/auth/services/auth_service.dart';

class CreateOrgArticleBottomsheet extends StatefulWidget {
  final Map<String, dynamic>? article; // if null => create, else update

  const CreateOrgArticleBottomsheet({super.key, this.article});

  @override
  State<CreateOrgArticleBottomsheet> createState() => _CreateOrgArticleBottomsheetState();
}

class _CreateOrgArticleBottomsheetState extends State<CreateOrgArticleBottomsheet> {
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
  bool _isPickingImage = false;
  bool _isPickingVideo = false;

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
    if (_isPickingImage) return; // prevent re-entrancy
    _isPickingImage = true;
    setState(() {});
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultiImage(imageQuality: 80);
      if (images != null && images.isNotEmpty) {
        pickedFiles = images.map((e) => File(e.path)).toList();
        mediaBase64 = pickedFiles.map((file) {
          final bytes = file.readAsBytesSync();
          return 'data:image/${file.path.split('.').last};base64,${base64Encode(bytes)}';
        }).toList();
        if (mounted) setState(() {});
      }
    } catch (e) {
      // Handle platform exceptions (picker already active) gracefully
      if (e is Exception) {
        // Optionally log or show a snackbar
      }
    } finally {
      _isPickingImage = false;
      if (mounted) setState(() {});
    }
  }

  Future<void> pickVideo() async {
    if (_isPickingVideo) return;
    _isPickingVideo = true;
    setState(() {});
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        pickedVideo = File(video.path);
        if (mounted) setState(() {});
      }
    } catch (e) {
      // ignore platform exceptions or show feedback
    } finally {
      _isPickingVideo = false;
      if (mounted) setState(() {});
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.article != null ? 'Update Article' : 'Create Article', style: theme.textTheme.titleLarge),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: titleController,
                  style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: subtitleController,
                  style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Subtitle',
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: excerptController,
                  style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Excerpt',
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: contentController,
                  style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
                  decoration: InputDecoration(
                    labelText: 'Content',
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.3)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                    ),
                  ),
                  maxLines: 6,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
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
                            // Type selector (article or video)
                            DropdownButtonFormField<String>(
                              value: selectedType,
                              isExpanded: true,
                              style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16),
                              decoration: InputDecoration(
                                labelText: 'Type',
                                labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.3)),
                                ),
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'article',
                                  child: Text('ARTICLE', style: TextStyle(color: theme.colorScheme.onSurface)),
                                ),
                                DropdownMenuItem(
                                  value: 'video',
                                  child: Text('VIDEO', style: TextStyle(color: theme.colorScheme.onSurface)),
                                ),
                                DropdownMenuItem(
                                  value: 'news_feed',
                                  child: Text('NEWS_FEED', style: TextStyle(color: theme.colorScheme.onSurface)),
                                ),
                              ],
                              onChanged: (v) => setState(() => selectedType = v!),
                            ),
                            const SizedBox(height: 12),
                            // When type is video, show video picker; otherwise show image picker
                            const SizedBox(height: 8),
                            if (selectedType == 'video') ...[
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: _isPickingVideo ? null : pickVideo,
                                  icon: const Icon(Icons.video_library),
                                  label: const Text('Pick Video'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              if (pickedVideo != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  pickedVideo!.path.split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                                ),
                              ],
                            ] else ...[
                              Center(
                                child: ElevatedButton.icon(
                                  onPressed: _isPickingImage ? null : pickImages,
                                  icon: const Icon(Icons.image),
                                  label: const Text('Pick Images'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                Row(
                  children: [
                    Text('Featured', style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16)),
                    Switch(
                      value: isFeatured,
                      onChanged: (v) => setState(() => isFeatured = v),
                      activeColor: theme.colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveArticle,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(widget.article != null ? 'Update' : 'Create'),
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

    final authService = Get.isRegistered<AuthService>() ? Get.find<AuthService>() : Get.put(AuthService(), permanent: true);
    final currentUser = await authService.getSavedUser();

    if (currentUser == null) {
      Get.snackbar('Authentication Required', 'Please login first to create articles', backgroundColor: Colors.orange, colorText: Colors.white, duration: const Duration(seconds: 4), snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final hasToken = await authService.hasToken();
    if (!hasToken) {
      Get.snackbar('Authentication Required', 'Your session has expired. Please login again', backgroundColor: Colors.orange, colorText: Colors.white, duration: const Duration(seconds: 4), snackPosition: SnackPosition.BOTTOM);
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
          Get.snackbar('Error', 'Video upload failed: ${e.toString()}', backgroundColor: Get.theme.colorScheme.error, colorText: Get.theme.colorScheme.onError);
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
          Get.snackbar('Success', 'Article updated', backgroundColor: Get.theme.colorScheme.primary, colorText: Get.theme.colorScheme.onPrimary);
        }
      } else {
        await articleController.createArticle(body);
        if (mounted) {
          Get.snackbar('Success', 'Article created', backgroundColor: Get.theme.colorScheme.primary, colorText: Get.theme.colorScheme.onPrimary);
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        Get.snackbar('Error', 'Failed to save article: ${e.toString()}', backgroundColor: Get.theme.colorScheme.error, colorText: Get.theme.colorScheme.onError);
      }
    }
  }
}
