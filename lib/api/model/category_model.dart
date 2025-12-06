class CategoryModel {
  final int id;
  final String slug;
  final String name;
  final String? description;
  final int? parentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CategoryModel> children;

  CategoryModel({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    this.parentId,
    required this.createdAt,
    required this.updatedAt,
    this.children = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      slug: json['slug'],
      name: json['name'],
      description: json['description'],
      parentId: json['parent_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      children: json['children'] != null
          ? (json['children'] as List)
          .map((c) => CategoryModel.fromJson(c))
          .toList()
          : [],
    );
  }
}