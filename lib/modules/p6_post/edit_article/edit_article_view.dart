import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_article_controller.dart';

class EditArticleView extends GetView<EditArticleController> {
  const EditArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(Get.context!);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor ?? theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text('New Article'.tr, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              onPressed: controller.savePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              ),
              child: Text('Post'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover upload area
              Text('Cover Image (Optional)'.tr, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Obx(() => GestureDetector(
                    onTap: controller.changeCover,
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.4), width: 1.2),
                      ),
                      child: controller.coverImage.value != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(controller.coverImage.value!, fit: BoxFit.cover),
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.cloud_upload_outlined, size: 36, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                                  const SizedBox(height: 8),
                                  Text('Upload a file'.tr + ' or ' + 'drag and drop'.tr, style: TextStyle(color: theme.colorScheme.primary)),
                                  const SizedBox(height: 6),
                                  Text('PNG, JPG, GIF up to 10MB', style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5), fontSize: 12)),
                                ],
                              ),
                            ),
                    ),
                  )),
              const SizedBox(height: 18),

              // Title
              Text('Title'.tr, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  hintText: 'Your article title'.tr,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),

              // Category
              Text('Category'.tr, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Obx(() => DropdownButtonFormField<String>(
                    value: controller.category.value,
                    items: controller.categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) {
                      if (v != null) controller.category.value = v;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  )),
              const SizedBox(height: 12),

              // Article content
              Text('Article Content'.tr, style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              TextField(
                controller: controller.contentController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Start writing your amazing article here...'.tr,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
