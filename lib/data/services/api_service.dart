import '../models/article_model.dart';
import '../models/notification_model.dart';

class ApiService {
  // Simulate API calls with sample data
  
  Future<List<ArticleModel>> fetchArticles() async {
    await Future.delayed(const Duration(seconds: 1));
    return _getSampleArticles();
  }

  Future<List<ArticleModel>> searchArticles(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getSampleArticles()
        .where((article) =>
            article.title.toLowerCase().contains(query.toLowerCase()) ||
            article.content.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<List<ArticleModel>> getArticlesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getSampleArticles()
        .where((article) => article.category == category)
        .toList();
  }

  Future<ArticleModel?> getArticleById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _getSampleArticles().firstWhere((article) => article.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getSampleNotifications();
  }

  // Private helper methods
  List<ArticleModel> _getSampleArticles() {
    final now = DateTime.now();
    return [
      ArticleModel(
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
        imageUrl: '',
        publishedAt: now.subtract(const Duration(hours: 2)),
        views: 15420,
        readTime: 5,
      ),
      ArticleModel(
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
      ArticleModel(
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
      ArticleModel(
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
      ArticleModel(
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
      ArticleModel(
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

  List<NotificationModel> _getSampleNotifications() {
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
}
