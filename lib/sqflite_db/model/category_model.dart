class CategoryModel {
  int? categoryId;
  String name;
  String description;
  String createdAt;
  String updatedAt;

  CategoryModel({
    this.categoryId,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'name': name,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) => CategoryModel(
    categoryId: map['category_id'],
    name: map['name'],
    description: map['description'],
    createdAt: map['created_at'],
    updatedAt: map['updated_at'],
  );
}