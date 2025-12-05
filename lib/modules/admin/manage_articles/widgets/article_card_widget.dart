import 'package:flutter/material.dart';

class ArticleCardWidget extends StatelessWidget {
  final String title;
  final Map<String, dynamic> author; // e.g., {'id': 1, 'display_name': 'John Doe'}
  final String status; // draft | published | archived
  final List<String> categories;
  final List<String> tags;
  final List<String> mediaAssets; // image, video, audio
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

  // Tag color
  Color _tagColor(String tag) => Colors.orangeAccent.shade100;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      // padding: const EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(16),
      //   boxShadow: const [
      //     BoxShadow(
      //       color: Colors.black12,
      //       blurRadius: 8,
      //       offset: Offset(0, 4),
      //     ),
      //   ],
      // ),
      child: Padding(
        padding: EdgeInsets.all(16),
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
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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

            // Author
            Text(
              'Author: ${author['display_name']}',
              style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 16),

            // Categories
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...categories.map(
                      (cat) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _categoryColor(cat),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cat,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Tags
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ...tags.map(
                      (tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _tagColor(tag),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: textTheme.bodySmall?.copyWith(
                        color: Colors.orangeAccent.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Media Assets
            Wrap(
              spacing: 8,
              children: [
                ...mediaAssets.map(
                      (asset) {
                    IconData icon;
                    Color color;
                    switch (asset) {
                      case 'image':
                        icon = Icons.image;
                        color = Colors.purple;
                        break;
                      case 'video':
                        icon = Icons.videocam;
                        color = Colors.redAccent;
                        break;
                      case 'audio':
                        icon = Icons.audiotrack;
                        color = Colors.orange;
                        break;
                      default:
                        icon = Icons.insert_drive_file;
                        color = Colors.grey;
                    }
                    return Icon(icon, color: color);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: onDelete,
                ),
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
}