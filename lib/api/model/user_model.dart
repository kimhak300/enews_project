class UserModel {
  final int id;
  final String displayName;
  final String email;
  final String role;
  final String? avatar;
  final bool isActive;

  UserModel({
    required this.id,
    required this.displayName,
    required this.email,
    required this.role,
    this.avatar,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    displayName: json['display_name'] ?? '',
    email: json['email'],
    role: json['role'] ?? 'user',
    avatar: json['avatar'],
    isActive: json['is_active'] ?? true,
  );
}