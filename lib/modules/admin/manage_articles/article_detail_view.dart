import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/article_controller.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/create_article_bottomsheet.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/update_article_bottomsheet.dart';

class ArticleDetailView extends StatefulWidget {
  final Map<String, dynamic> article;

  const ArticleDetailView({super.key, required this.article});

  @override
  State<ArticleDetailView> createState() => _ArticleDetailViewState();
}

class _ArticleDetailViewState extends State<ArticleDetailView> {

  final ArticleController controller = Get.put(ArticleController());

  int currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final media = List<String>.from(widget.article['media'] ?? []);
    final categories = List<String>.from(widget.article['categories'] ?? []);
    final content = widget.article['content_html'] ?? '';
    final title = widget.article['title'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showUpdateBottomSheet();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.paddingS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (media.isNotEmpty) _image(),
            SizedBox(height: AppSpacing.paddingL),
            _title(),
            if (categories.isNotEmpty) _category(),
            if (categories.isNotEmpty) SizedBox(height: AppSpacing.paddingL),
            if (content.isNotEmpty) _content(),
            if (content.isNotEmpty) SizedBox(height: AppSpacing.paddingL),
          ],
        ),
      ),
    );
  }

  // ---------- Image Section ----------
  Widget _image() {
    final media = List<String>.from(widget.article['media'] ?? []);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            base64Decode(media[currentImageIndex].split(',').last),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: media.length,
            itemBuilder: (context, index) {
              final bytes = base64Decode(media[index].split(',').last);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: currentImageIndex == index
                      ? const EdgeInsets.all(3)
                      : EdgeInsets.zero,
                  decoration: currentImageIndex == index
                      ? BoxDecoration(
                    border: Border.all(
                        color: Colors.blueAccent, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  )
                      : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      bytes,
                      width: 60,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  // ---------- Title Section ----------
  Widget _title() {
    final title = widget.article['title'] ?? '';
    final subtitle = widget.article['subtitle'] ?? '';
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }

  // ---------- Categories Section ----------
  Widget _category() {
    final categories = List<String>.from(widget.article['categories'] ?? []);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: categories
          .map(
            (cat) => Chip(
          backgroundColor: Colors.blueAccent.shade100,
          label: Text(
            cat,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent.shade700,
            ),
          ),
        ),
      )
          .toList(),
    );
  }

  // ---------- Content Section ----------
  Widget _content() {
    final content = widget.article['content_html'] ?? '';
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // ---------- Show Update BottomSheet ----------
  void _showUpdateBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => UpdateArticleBottomsheet(article: widget.article),
    ).then((_) {
      setState(() {});
    });
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Article'),
        content: const Text('Are you sure you want to delete this article?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // close dialog
              await controller.deleteArticle(widget.article['id']);
              Navigator.pop(context); // close detail screen
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
