import 'package:flutter/material.dart';
import 'package:newshub/modules/admin/manage_categories/widgets/add_category_bottomsheet.dart';

class ManageCategoriesView extends StatelessWidget {
  const ManageCategoriesView({super.key});

  // Example category data with nested structure
  final List<Map<String, dynamic>> categories = const [
    {
      'name': 'Technology',
      'tags': ['Flutter', 'Dart', 'AI'],
      'subcategories': [
        {
          'name': 'Mobile',
          'tags': ['iOS', 'Android'],
        },
        {
          'name': 'Web',
          'tags': ['React', 'Angular'],
        },
      ],
    },
    {
      'name': 'Design',
      'tags': ['UI', 'UX', 'Figma'],
      'subcategories': [],
    },
    {
      'name': 'Education',
      'tags': ['E-learning', 'Tutorials'],
      'subcategories': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Categories / Tags'),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Add new category
            },
          ),
        ],
      ),
      // Floating Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => AddCategoryBottomsheet(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: categories.map((category) {
            return CategoryCardWidget(category: category, textTheme: textTheme);
          }).toList(),
        ),
      ),
    );
  }
}

// Category Card Widget
class CategoryCardWidget extends StatelessWidget {
  final Map<String, dynamic> category;
  final TextTheme textTheme;

  const CategoryCardWidget({
    super.key,
    required this.category,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Name + Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category['name'],
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Tags
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...category['tags'].map<Widget>((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag,
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.orangeAccent.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 8),

          // Subcategories
          if (category['subcategories'].isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subcategories:',
                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ...category['subcategories'].map<Widget>((sub) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(sub['name'], style: textTheme.bodyMedium)),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 20),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }
}
