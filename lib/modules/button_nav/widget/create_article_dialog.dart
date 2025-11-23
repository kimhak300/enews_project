import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/widget/blur_loading_widget.dart';
import 'package:newshub/app/widget/title_widget.dart';
import 'package:newshub/sqflite_db/controller/article_controller.dart';
import 'package:newshub/sqflite_db/model/artical_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateArticleDialog extends StatefulWidget {
  const CreateArticleDialog({super.key});

  @override
  State<CreateArticleDialog> createState() => _CreateArticleDialogState();
}

class _CreateArticleDialogState extends State<CreateArticleDialog> {

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();

  final ArticleController _articleController = Get.put(ArticleController());

  /// Example categories (you can fetch from DB)
  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'News'},
    {'id': 2, 'name': 'Tech'},
    {'id': 3, 'name': 'Lifestyle'},
  ];

  int? _selectedCategoryId;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final int? userId = prefs.getInt('userId');

    if (userId == null) {
      Get.snackbar(
        'Error',
        'User not logged in',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final now = DateTime.now().toIso8601String();

    final newArticle = ArticleModel(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      imageUrl: _imageController.text.trim(),
      categoryId: _selectedCategoryId!,
      authorId: userId,
      publishedAt: now,
      createdAt: now,
      updatedAt: now,
    );

    _articleController.addArticle(newArticle);

    BlurLoadingWidget.show();
    await Future.delayed(const Duration(seconds: 2));
    BlurLoadingWidget.hide();

    Get.back(); // Close dialog
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TitleWidget(title: 'Create Article'),
                const SizedBox(height: 20),

                // Title Field
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Title required' : null,
                ),
                const SizedBox(height: 16),

                // Content Field
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Content',
                  ),
                  maxLines: 5,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Content required' : null,
                ),
                const SizedBox(height: 16),

                // Image Field
                TextFormField(
                  controller: _imageController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                  ),
                ),
                const SizedBox(height: 16),

                // Category Dropdown
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                  ),
                  items: _categories.map((cat) => DropdownMenuItem<int>(
                      value: cat['id'],
                      child: Text(cat['name']),
                    ),
                  ).toList(),
                  value: _selectedCategoryId,
                  onChanged: (val) {
                    setState(() {
                      _selectedCategoryId = val;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Please select a category' : null,
                ),
                const SizedBox(height: 20),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Create Article'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}