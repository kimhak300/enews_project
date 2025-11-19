import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../app/models/post_model.dart';
import '../../p1_home/home_controller.dart';
import '../../p2_dashboard/dashboard_controller.dart';

class EditVideoController extends GetxController {
  final titleController = TextEditingController();
  final topic = ''.obs;
  final coverImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Post? editingPost;

  @override
  void onInit() {
    super.onInit();
    // If editing existing post, load its data
    if (Get.arguments != null && Get.arguments is Post) {
      editingPost = Get.arguments as Post;
      titleController.text = editingPost!.title;
      topic.value = editingPost!.topic;
      if (editingPost!.coverImage != null) {
        coverImage.value = File(editingPost!.coverImage!);
      }
    }
  }

  Future<void> changeCover() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      coverImage.value = File(image.path);
    }
  }

  Future<void> editCover() async {
    // For simplicity, just open gallery again
    // In real app, you might want to add image editing functionality
    await changeCover();
  }

  void addTopic() {
    Get.dialog(
      AlertDialog(
        
        title: Text('add_topic'.tr),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'enter_topic'.tr,
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              topic.value = value.startsWith('#') ? value : '#$value';
              Get.back();
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
        ],
      ),
    );
  }

  void savePost() {
    if (titleController.text.isEmpty) {
      Get.snackbar(
        'error'.tr,
        'title_is_required'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final post = Post(
      id: editingPost?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: titleController.text,
      coverImage: coverImage.value?.path,
      topic: topic.value,
      createdAt: editingPost?.createdAt ?? DateTime.now(),
      authorId: 'current_user',
      authorName: 'User Name',
      authorImage: null,
    );

    // Add to dashboard controller's posts list
    final dashboardCtrl = Get.find<DashboardController>();
    if (editingPost != null) {
      // Update existing post
      final index = dashboardCtrl.posts
          .indexWhere((p) => p.id == editingPost!.id);
      if (index != -1) {
        dashboardCtrl.posts[index] = post;
        // ensure persisted
        try {
          dashboardCtrl.savePosts();
        } catch (_) {}
      }
    } else {
      // Add new post
      dashboardCtrl.posts.insert(0, post);
      // ensure persisted
      try {
        dashboardCtrl.savePosts();
      } catch (_) {}
    }

    // Update home controller to refresh the view
    try {
      final homeCtrl = Get.find<HomeController>();
      homeCtrl.update();
    } catch (e) {
      // HomeController might not be initialized yet
    }

    Get.back();
    Get.snackbar(
      'success'.tr,
      editingPost != null ? 'post_updated_successfully'.tr : 'post_created_successfully'.tr,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }
}
