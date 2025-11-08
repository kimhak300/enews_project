// class UserModel {
//   final String id;
//   final String name;
//   final String email;
//   final String? phone;
//   final String? avatar;
//   final DateTime createdAt;

//   UserModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     this.phone,
//     this.avatar,
//     required this.createdAt,
//   });

//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'],
//       avatar: json['avatar'],
//       createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'avatar': avatar,
//       'created_at': createdAt.toIso8601String(),
//     };
//   }

//   // For legacy compatibility with auth service
//   factory UserModel.fromLegacyMap(Map<String, dynamic> map) {
//     return UserModel(
//       id: map['email'] ?? '',
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//       phone: map['phone'],
//       avatar: map['avatar'],
//       createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
//     );
//   }

//   Map<String, dynamic> toLegacyMap() {
//     return {
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'avatar': avatar,
//       'created_at': createdAt.toIso8601String(),
//     };
//   }
// }

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatar;
  final bool isAdmin;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatar,
    this.isAdmin = false,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatar: json['avatar'],
      isAdmin: json['is_admin'] ?? false,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'is_admin': isAdmin,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
