import 'package:flutter/material.dart';
import 'package:newshub/data/services/article_service.dart';
import 'package:newshub/data/services/auth_service.dart';
import 'package:newshub/data/services/category_service.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final _authService = AuthService();
  final _articleService = ArticleService();
  final _categoryService = CategoryService();
  
  String _result = 'No test run yet';
  bool _loading = false;

  Future<void> _testConnection() async {
    setState(() {
      _loading = true;
      _result = 'Testing connection...';
    });

    try {
      final articles = await _articleService.getArticles();
      setState(() {
        _result = '✅ SUCCESS!\n\nFound ${articles.length} articles\n\n' +
            'First article: ${articles.first.title}';
      });
    } catch (e) {
      setState(() {
        _result = '❌ ERROR!\n\n$e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _testCategories() async {
    setState(() {
      _loading = true;
      _result = 'Loading categories...';
    });

    try {
      final categories = await _categoryService.getCategories();
      setState(() {
        _result = '✅ SUCCESS!\n\nFound ${categories.length} categories\n\n' +
            categories.map((c) => '• ${c.name}').join('\n');
      });
    } catch (e) {
      setState(() {
        _result = '❌ ERROR!\n\n$e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Connection Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _loading ? null : _testConnection,
              child: const Text('Test Articles API'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loading ? null : _testCategories,
              child: const Text('Test Categories API'),
            ),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(_result),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}