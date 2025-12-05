import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/controllers/id_controller.dart';
import '../../../sqflite_db/controller/bookmark_controller.dart';

class MyBookmarkScreen extends StatelessWidget {

  final BookmarkController bookmarkController = Get.put(BookmarkController());
  final IdController idController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookmarks")),
      body: Obx(() {
        final bookmarks = bookmarkController.bookmarks;

        if (bookmarks.isEmpty) {
          return const Center(child: Text("No bookmarks found."));
        }

        return ListView.builder(
          itemCount: bookmarks.length,
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, index) {
            final item = bookmarks[index];
            return Card(
              child: ListTile(
                title: Text("Article ID: ${item.articleId}"),
                subtitle: Text(item.createdAt),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => bookmarkController.toggleBookmark(item.articleId),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}