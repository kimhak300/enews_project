class UserModel {
  int? userId;
  String name;
  String email;
  String password;
  String? profileImage;
  String createdAt;
  String updatedAt;

  UserModel({
    this.userId,
    required this.name,
    required this.email,
    required this.password,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'password': password,
      'profile_image': profileImage,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['user_id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      profileImage: map['profile_image'],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }
}