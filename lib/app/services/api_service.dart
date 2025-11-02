import '../models/article_model.dart';
import '../models/notification_model.dart';

class ApiService {
  static List<Article> getSampleArticles() {
    final now = DateTime.now();
    return [
      Article(
        id: '1',
        title: 'Breaking: Tech Giant Announces Revolutionary AI System',
        content: '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris.

Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

Key Highlights:
• Revolutionary advancement in AI technology
• Expected to impact multiple industries
• Global collaboration effort

Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.
        ''',
        category: 'Technology',
        author: 'Sarah Johnson',
        authorImage: '',
        imageUrl: 'https://s.yimg.com/ny/api/res/1.2/.yAqG.tnQjApKacZldHp7Q--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD02NzY-/https://s.yimg.com/os/creatr-uploaded-images/2025-10/c9811720-b053-11f0-bdbf-79176cd6f73f',
        publishedAt: now.subtract(const Duration(hours: 2)),
        views: 15420,
        readTime: 5,
      ),
      Article(
        id: '2',
        title: 'Global Markets Surge on Economic Optimism',
        content: 'Latest developments in global markets...',
        category: 'Business',
        author: 'Michael Chen',
        authorImage: '',
        imageUrl: '',
        publishedAt: now.subtract(const Duration(hours: 4)),
        views: 8932,
        readTime: 4,
      ),
      Article(
        id: '3',
        title: 'Championship Finals: Historic Victory',
        content: 'Sports news coverage...',
        category: 'Sports',
        author: 'David Martinez',
        authorImage: '',
        imageUrl: '',
        publishedAt: now.subtract(const Duration(hours: 6)),
        views: 24567,
        readTime: 3,
      ),
      Article(
        id: '4',
        title: 'Health: Breakthrough in Medical Research',
        content: 'New study reveals...',
        category: 'Health',
        author: 'Dr. Emily White',
        authorImage: '',
        imageUrl: '',
        publishedAt: now.subtract(const Duration(hours: 8)),
        views: 12890,
        readTime: 6,
      ),
      Article(
        id: '5',
        title: 'Scientists Discover New Planet in Nearby Star System',
        content: 'Astronomical breakthrough...',
        category: 'Science',
        author: 'Prof. James Wilson',
        authorImage: '',
        imageUrl: '',
        publishedAt: now.subtract(const Duration(hours: 12)),
        views: 18765,
        readTime: 7,
      ),
      Article(
        id: '6',
        title: 'Entertainment: New Blockbuster Breaks Records',
        content: 'Movie industry news...',
        category: 'Entertainment',
        author: 'Lisa Anderson',
        authorImage: '',
        imageUrl: '',
        publishedAt: now.subtract(const Duration(days: 1)),
        views: 34521,
        readTime: 4,
      ),
    ];
  }

  static List<NotificationModel> getSampleNotifications() {
    final now = DateTime.now();
    return List.generate(
      10,
      (index) => NotificationModel(
        id: 'notif_$index',
        title: 'Breaking News Alert ${index + 1}',
        message: 'New article published in Technology category',
        timestamp: now.subtract(Duration(hours: index + 1)),
        type: 'article',
        isRead: index >= 3,
      ),
    );
  }

  static Future<List<Article>> fetchArticles() async {
    await Future.delayed(const Duration(seconds: 1));
    return getSampleArticles();
  }

  static Future<List<Article>> searchArticles(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return getSampleArticles()
        .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()) ||
            article.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  static Future<List<Article>> getArticlesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return getSampleArticles()
        .where((article) => article.category == category)
        .toList();
  }
}
