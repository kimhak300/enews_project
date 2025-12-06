import 'dart:convert';
import 'package:flutter/material.dart';

class ArticleCardWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> author;
  final String status;
  final List<String> categories;
  final List<String> tags;
  final List<String> mediaAssets;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onPublish;

  const ArticleCardWidget({
    super.key,
    required this.title,
    required this.author,
    required this.status,
    this.categories = const [],
    this.tags = const [],
    this.mediaAssets = const [],
    this.onEdit,
    this.onDelete,
    this.onPublish,
  });

  // Status color
  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
        return Colors.orangeAccent;
      case 'published':
        return Colors.green;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.blueAccent;
    }
  }

  // Category color
  Color _categoryColor(String category) => Colors.blueAccent.shade100;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: textTheme.bodySmall?.copyWith(
                      color: _statusColor(status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text('Author: ${author['display_name']}',
                style: textTheme.bodyMedium),

            const SizedBox(height: 12),

            // Categories
            if (categories.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: categories
                    .map(
                      (cat) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _categoryColor(cat),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          cat,
                          style: textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent.shade700),
                        ),
                      ),
                    )
                    .toList(),
              ),

            if (categories.isNotEmpty) const SizedBox(height: 12),

            // Media icon (only one)
            if (mediaAssets.isNotEmpty)
              GestureDetector(
                onTap: (){
                  _showMediaDialog(context);
                },
                child: Icon(Icons.image, size: 40, color: Colors.blueAccent),
              ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: onDelete,
                  ),
                if (onPublish != null)
                  IconButton(
                    icon: const Icon(Icons.publish, color: Colors.green),
                    onPressed: onPublish,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMediaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final pageController = PageController();
        return StatefulBuilder(builder: (context, setState) {
          int currentIndex = 0;

          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            contentPadding: const EdgeInsets.all(8),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: mediaAssets.length,
                      onPageChanged: (index) =>
                          setState(() => currentIndex = index),
                      itemBuilder: (_, index) {
                        final bytes =
                            base64Decode(mediaAssets[index].split(',').last);
                        return Image.memory(bytes, fit: BoxFit.contain);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Page indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      mediaAssets.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == i ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: currentIndex == i
                              ? Colors.blueAccent
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              )
            ],
          );
        });
      },
    );
  }
}
