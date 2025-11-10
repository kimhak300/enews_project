import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_post_controller.dart';

class EditPostView extends GetView<EditPostController> {
  const EditPostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                   Expanded(
                    child: Text(
                      'edit_info'.tr,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: controller.savePost,
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: Colors.grey[300],
                      // foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text('post'.tr, style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            // Body content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Cover image section
                    Obx(() => Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 300,
                              color: Colors.black,
                              child: controller.coverImage.value != null
                                  ? Image.file(
                                      controller.coverImage.value!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Center(
                                      child: Icon(Icons.image,
                                          size: 100, color: Colors.grey),
                                    ),
                            ),
                            // Positioned(
                            //   bottom: 16,
                            //   left: 16,
                            //   child: ElevatedButton(
                            //     onPressed: controller.changeCover,
                            //     style: ElevatedButton.styleFrom(
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(20),
                            //       ),
                            //     ),
                            //     child: Text('change_cover'.tr),
                            //   ),
                            // ),
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: ElevatedButton(
                                onPressed: controller.editCover,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text('edit_cover'.tr),
                              ),
                            ),
                          ],
                        )),

            // Title section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      Text(
                        '*'.tr,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'title'.tr,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.titleController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'interested_headlines_for_more_people_to_see'.tr,
                      hintStyle: TextStyle(color: Colors.grey[500]), 
                      filled: true,
                      // fillColor: Colors.grey[300],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Topic section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'topic'.tr,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: controller.addTopic,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[300], 
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Obx(() => Row(
                            children: [
                              Icon(Icons.add),
                              const SizedBox(width: 8),
                              Text(
                                controller.topic.value.isEmpty
                                    ? 'add #'.tr
                                    : controller.topic.value,
                                style: TextStyle(
                                  color: controller.topic.value.isEmpty
                                      ? Colors.grey[600]
                                      : Colors.black,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
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
