import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_video_controller.dart';

class EditVideoView extends GetView<EditVideoController> {
  const EditVideoView({super.key});

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
        title: Text(
          'edit_info'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: ElevatedButton(
              onPressed: controller.savePost,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              ),
              child: Text('post'.tr, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Body content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video preview section
                    Center(
                      child: Obx(() => Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: controller.coverImage.value != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      controller.coverImage.value!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.videocam_rounded,
                                      size: 64,
                                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                                    ),
                                  ),
                          )),
                    ),
                    const SizedBox(height: 20),

                    // Edit Video button
                    Center(
                      child: ElevatedButton(
                        onPressed: controller.editCover,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'edit_cover'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Title section
                    Row(
                      children: [
                        Text(
                          '*',
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'title'.tr,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: controller.titleController,
                      maxLines: 3,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: 'interested_headlines_for_more_people_to_see'.tr,
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Topic section
                    Text(
                      'topic'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: controller.addTopic,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline.withOpacity(0.2),
                          ),
                        ),
                        child: Obx(() => Row(
                              children: [
                                Icon(
                                  Icons.add,
                                  color: controller.topic.value.isEmpty
                                      ? theme.colorScheme.onSurface.withOpacity(0.5)
                                      : theme.colorScheme.onSurface,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  controller.topic.value.isEmpty
                                      ? 'add #'.tr
                                      : controller.topic.value,
                                  style: TextStyle(
                                    color: controller.topic.value.isEmpty
                                        ? theme.colorScheme.onSurface.withOpacity(0.4)
                                        : theme.colorScheme.onSurface,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
