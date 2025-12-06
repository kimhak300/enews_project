import 'package:flutter/material.dart';
import 'package:newshub/modules/admin/manage_articles/article_detail_view.dart';

class ArticleCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> categories;
  final List<String>? images;
  final Map<String, dynamic> articleData;

  const ArticleCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.categories,
    required this.articleData,
    this.images,
  });

  String _getInitials(String text) {
    final parts = text.trim().split(" ");
    if (parts.length == 1) {
      return text.substring(0, 2).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String? firstImage =
    (images != null && images!.isNotEmpty) ? images!.first : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailView(article: articleData),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //---------------------------------------------------------
              // 1️⃣ TOP ROW → Image + Title + Categories (on right)
              //---------------------------------------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Image or Fallback Avatar ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: firstImage != null
                        ? Image.network(
                      firstImage,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallbackAvatar(),
                    )
                        : _fallbackAvatar(),
                  ),

                  const SizedBox(width: 12),

                  // TITLE + SUBTITLE
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Title ---
                        Text(
                          title,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 4),

                        // --- Subtitle ---
                        if (subtitle.isNotEmpty)
                          Text(
                            subtitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.black87),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // --- Categories on the Right ---
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: categories
                        .map(
                          (cat) => Container(
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          cat,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //---------------------------------------------------------
  // Fallback Avatar (if no image)
  //---------------------------------------------------------
  Widget _fallbackAvatar() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          _getInitials(title),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ),
    );
  }
}