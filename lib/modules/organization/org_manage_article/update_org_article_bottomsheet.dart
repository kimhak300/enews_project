import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newshub/api/controller/article_controller.dart';
import 'package:newshub/api/service/article_service.dart';
import 'package:newshub/api/controller/category_controller.dart';

class UpdateOrgArticleBottomsheet extends StatefulWidget {
  final Map<String, dynamic> article;

  const UpdateOrgArticleBottomsheet({super.key, required this.article});

  @override
  State<UpdateOrgArticleBottomsheet> createState() => _UpdateOrgArticleBottomsheetState();
}

class _UpdateOrgArticleBottomsheetState extends State<UpdateOrgArticleBottomsheet> {
  final _formKey = GlobalKey<FormState>();
  final ArticleController articleController = Get.find();
  final CategoryController categoryController = Get.find();

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

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    subtitleController = TextEditingController();
    excerptController = TextEditingController();
    contentController = TextEditingController();

    categoryController.fetchCategories();

    final a = widget.article;
    titleController.text = a['title'] ?? '';
    subtitleController.text = a['subtitle'] ?? '';
    excerptController.text = a['excerpt'] ?? '';
    contentController.text = a['content_html'] ?? '';
    selectedStatus = a['status'] ?? 'draft';
    selectedType = a['type'] ?? 'article';
    isFeatured = a['is_featured'] ?? false;
    selectedCategories = List<String>.from(a['categories'] ?? []);
    selectedTags = List<String>.from(a['tags'] ?? []);
    mediaBase64 = List<String>.from(a['media'] ?? []);
  }

  File? pickedVideo;

  Future<void> pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      pickedVideo = File(video.path);
      setState(() {});
    }
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Update Article', style: theme.textTheme.titleLarge),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(controller: titleController, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: subtitleController, decoration: const InputDecoration(labelText: 'Subtitle')),
                const SizedBox(height: 12),
                TextFormField(controller: excerptController, decoration: const InputDecoration(labelText: 'Excerpt')),
                const SizedBox(height: 12),
                TextFormField(controller: contentController, decoration: const InputDecoration(labelText: 'Content'), maxLines: 6, validator: (v) => v!.isEmpty ? 'Required' : null),
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
                DropdownButtonFormField<String>(
                  value: selectedType,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: const [
                    DropdownMenuItem(value: 'article', child: Text('ARTICLE')),
                    DropdownMenuItem(value: 'video', child: Text('VIDEO')),
                    DropdownMenuItem(value: 'news_feed', child: Text('NEWS_FEED')),
                  ],
                  onChanged: (v) => setState(() => selectedType = v!),
                ),
                const SizedBox(height: 8),
                if (selectedType == 'video') ...[
                  Center(
                    child: ElevatedButton.icon(onPressed: pickVideo, icon: const Icon(Icons.video_library), label: const Text('Pick Video'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))),
                  ),
                  if (pickedVideo != null) ...[
                    const SizedBox(height: 8),
                    Text(pickedVideo!.path.split('/').last, overflow: TextOverflow.ellipsis),
                  ],
                ] else ...[
                  Center(child: ElevatedButton.icon(onPressed: pickImages, icon: const Icon(Icons.image), label: const Text('Pick Images'), style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
                ],
                const SizedBox(height: 12),
                Row(children: [const Text('Featured'), Switch(value: isFeatured, onChanged: (v) => setState(() => isFeatured = v))]),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateArticle,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text('Update'),
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
    List<String> mediaPayload = mediaBase64;

    // If updating to video type and user picked a new video, upload it
    if (selectedType == 'video' && pickedVideo != null) {
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
      'status': selectedStatus,
      'is_featured': isFeatured,
      'categories': selectedCategories,
      'tags': selectedTags,
      'media': mediaPayload,
      'language_code': 'en',
      'type': selectedType,
    };

    final id = widget.article['id'];
    try {
      await articleController.updateArticle(id, body);
      if (mounted) {
        Get.snackbar('Success', 'Article updated successfully', backgroundColor: Get.theme.colorScheme.primary, colorText: Get.theme.colorScheme.onPrimary, snackPosition: SnackPosition.BOTTOM);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar('Error', 'Failed to update article: ${e.toString()}', backgroundColor: Get.theme.colorScheme.error, colorText: Get.theme.colorScheme.onError, snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
