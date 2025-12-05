import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_spacing.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/article_card_widget.dart';
import 'package:newshub/modules/admin/manage_articles/widgets/create_article_bottomsheet.dart';

class ManageArticlesView extends StatelessWidget {
  const ManageArticlesView({super.key});

  final List<String> tabs = const ['All', 'Draft', 'Published'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Articles'),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const CreateArticleBottomSheet(),
            );
          },
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingS),
          child: Column(
            children: [
              _tabHeader(),
              SizedBox(height: AppSpacing.paddingL),
              _tabBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blueAccent.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        dividerHeight: 0,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        unselectedLabelColor: Colors.white,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        tabs: tabs.map((tab) => Container(
          padding: const EdgeInsets.symmetric(
              vertical: 8, horizontal: 8
          ),
          child: Center(child: Text(tab)
          ),
        ),
        ).toList(),
      ),
    );
  }

  Widget _tabBody() {
    return Expanded(
      child: TabBarView(
        children: tabs.map((tab) {
          return Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search articles...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),

              const SizedBox(height: 16),

              // Fixed UI – Only one card
              ArticleCardWidget(
                title: "Flutter State Management",
                author: {'id': 1, 'display_name': 'John Doe'},
                status: "draft",
                categories: ["Flutter", "Programming"],
                tags: ["GetX", "State", "UI"],
                mediaAssets: ["image", "video"],
                onEdit: () {},
                onDelete: () {},
                onPublish: () {},
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}