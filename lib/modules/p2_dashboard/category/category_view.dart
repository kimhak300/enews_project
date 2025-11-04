import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'category_controller.dart';
import 'media_service.dart';
import 'video_player_screen.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(CategoryController());
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title under Device Traffic
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
        ),

        // Create New button (gradient like screenshot)
        _CreateButton(onPressed: () => _openCreateDialog(context, ctrl)),
        const SizedBox(height: 12),

        // List of category cards
        Obx(() {
          final items = ctrl.categories;
          if (items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: Text('No categories yet'.tr,
                    style: theme.textTheme.bodyMedium),
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return _CategoryCard(
                item: item,
                onEdit: () => _openEditDialog(context, ctrl, item),
                onDelete: () => _confirmDelete(context, ctrl, item),
              );
            },
          );
        }),
      ],
    );
  }

  void _openCreateDialog(BuildContext context, CategoryController ctrl) {
    _openFormDialog(context, ctrl);
  }

  void _openEditDialog(
      BuildContext context, CategoryController ctrl, CategoryModel item) {
    _openFormDialog(context, ctrl, existing: item);
  }

  Future<void> _confirmDelete(
      BuildContext context, CategoryController ctrl, CategoryModel item) async {
    final theme = Theme.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('delete_category'.tr),
        content: Text('Are you sure you want to delete "${item.name}"?'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );

    if (ok == true) {
      await ctrl.remove(item);
      Get.snackbar('deleted'.tr, 'category_removed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: theme.colorScheme.surface,
          colorText: theme.colorScheme.onSurface);
    }
  }

  Future<void> _openFormDialog(BuildContext context, CategoryController ctrl,
      {CategoryModel? existing}) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final tagCtrl = TextEditingController(text: existing?.tag ?? 'technology'.tr);
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    Color selectedColor = Color(existing?.colorValue ?? Colors.purple.value);
    
    // Media picker state
    final RxString? selectedMediaPath = (existing?.mediaPath ?? '').obs;
    final RxString? selectedMediaType = (existing?.mediaType ?? '').obs;
    final ImagePicker picker = ImagePicker();

    Future<void> pickImage() async {
      try {
        final XFile? image = await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          final savedPath = await MediaService.saveMediaFile(image.path, 'image'.tr);
          selectedMediaPath?.value = savedPath;
          selectedMediaType?.value = 'image'.tr;
        }
      } catch (e) {
        Get.snackbar(
          'error'.tr,
          'failed_to_select_image'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    Future<void> pickVideo() async {
      try {
        final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
        if (video != null) {
          final savedPath = await MediaService.saveMediaFile(video.path, 'video'.tr);
          selectedMediaPath?.value = savedPath;
          selectedMediaType?.value = 'video'.tr;
          
          Get.snackbar(
            'video_selected'.tr,
            'video_ready_to_use'.tr,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 2),
          );
        }
      } catch (e) {
        Get.snackbar(
          'error'.tr,
          'failed_to_select_video'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    void clearMedia() {
      selectedMediaPath?.value = '';
      selectedMediaType?.value = '';
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'create_new_category'.tr : 'edit_category'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'name'.tr,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: tagCtrl,
                decoration:  InputDecoration(
                  labelText: 'tag'.tr,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration:  InputDecoration(
                  labelText: 'description'.tr,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                   Text('color:'.tr),
                  const SizedBox(width: 12),
                  _ColorDot(color: Colors.blue, selected: selectedColor == Colors.blue, onTap: () => selectedColor = Colors.blue),
                  _ColorDot(color: Colors.purple, selected: selectedColor == Colors.purple, onTap: () => selectedColor = Colors.purple),
                  _ColorDot(color: Colors.green, selected: selectedColor == Colors.green, onTap: () => selectedColor = Colors.green),
                  _ColorDot(color: Colors.red, selected: selectedColor == Colors.red, onTap: () => selectedColor = Colors.red),
                  _ColorDot(color: Colors.orange, selected: selectedColor == Colors.orange, onTap: () => selectedColor = Colors.orange),
                ],
              ),
              const SizedBox(height: 16),
              Text('media:'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              // Media picker buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.image, size: 18),
                      label: Text('image'.tr),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickVideo,
                      icon: const Icon(Icons.video_library, size: 18),
                      label: Text('video'.tr),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Media preview
              Obx(() {
                final path = selectedMediaPath?.value ?? '';
                final type = selectedMediaType?.value ?? '';
                if (path.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      if (type == 'image'.tr)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.file(
                            File(path),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[200],
                              child: const Icon(Icons.broken_image),
                            ),
                          ),
                        )
                      else
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => VideoPlayerScreen(
                                  videoPath: path,
                                  title: 'video_preview'.tr,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.play_circle_outline, color: Colors.white, size: 32),
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          path.split('/').last,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: clearMedia,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child:  Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(existing == null ? 'create'.tr : 'save'.tr),
          ),
        ],
      ),
    );

    if (ok == true) {
      final mediaPath = selectedMediaPath?.value.isEmpty == true ? null : selectedMediaPath?.value;
      final mediaType = selectedMediaType?.value.isEmpty == true ? null : selectedMediaType?.value;
      
      if (existing == null) {
        await ctrl.create(
          name: nameCtrl.text.trim(),
          tag: tagCtrl.text.trim(),
          description: descCtrl.text.trim(),
          color: selectedColor,
          mediaPath: mediaPath,
          mediaType: mediaType,
        );
      } else {
        await ctrl.updateCategory(
          existing,
          name: nameCtrl.text.trim(),
          tag: tagCtrl.text.trim(),
          description: descCtrl.text.trim(),
          color: selectedColor,
          mediaPath: mediaPath,
          mediaType: mediaType,
        );
      }
    }
  }
}

class _CreateButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CreateButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.black26,
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            alignment: Alignment.center,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 8),
                Text('create_new_category'.tr,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _CategoryCard({required this.item, required this.onEdit, required this.onDelete});

  Future<void> _handleVideoTap(BuildContext context, CategoryModel item) async {
    if (item.mediaPath == null || item.mediaPath!.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'video_path_is_empty'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    String playablePath = item.mediaPath!;

    // Migrate cached files to permanent storage
    if (MediaService.isCachePath(playablePath)) {
      final migratedPath = await MediaService.migrateCachedFile(playablePath, 'video'.tr);
      if (migratedPath != null) {
        playablePath = migratedPath;
        // Update stored path
        final ctrl = Get.find<CategoryController>();
        await ctrl.updateCategory(
          item,
          name: item.name,
          tag: item.tag,
          description: item.description,
          color: Color(item.colorValue),
          mediaPath: playablePath,
          mediaType: item.mediaType,
        );
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          videoPath: playablePath,
          title: item.name,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = Color(item.colorValue);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top colored bar
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                // Chip
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: barColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: barColor.withOpacity(0.4)),
                  ),
                  child: Text(item.tag,
                      style: TextStyle(
                          color: barColor, fontWeight: FontWeight.w600, fontSize: 12)),
                ),
                const SizedBox(height: 12),
                // Media preview if available
                if (item.mediaPath != null && item.mediaPath!.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: item.mediaType == 'image'.tr
                        ? Image.file(
                            File(item.mediaPath!),
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 160,
                              color: Colors.grey[200],
                              child: const Center(child: Icon(Icons.broken_image, size: 40)),
                            ),
                          )
                        : GestureDetector(
                            onTap: () => _handleVideoTap(context, item),
                            child: Container(
                              height: 160,
                              color: Colors.black87,
                              child: const Center(
                                child: Icon(Icons.play_circle_outline, color: Colors.white, size: 64),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  item.description,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 12),
                // Meta row
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(item.author, style: theme.textTheme.bodySmall),
                    const SizedBox(width: 16),
                    const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(item.date, style: theme.textTheme.bodySmall),
                    const SizedBox(width: 16),
                    const Icon(Icons.remove_red_eye, size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text(item.views.toString(), style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit, size: 18),
                        label:  Text('edit'.tr),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onDelete,
                        style: FilledButton.styleFrom(backgroundColor: Colors.red),
                        icon: const Icon(Icons.delete, size: 18),
                        label:  Text('delete'.tr),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _ColorDot({required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: selected ? Colors.black : Colors.white, width: 2),
        ),
      ),
    );
  }
}
