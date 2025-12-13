class RoleModel {
  final int id;
  final String roleName;
  final String? description;

  RoleModel({
    required this.id,
    required this.roleName,
    this.description,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] ?? 0,
      roleName: json['role_name'] ?? '',
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_name': roleName,
      'description': description,
    };
  }
}

class UserModel {
  final int id;
  final String email;
  final String? fullName;
  final String? displayName;
  final String? phone;
  final String? slug;
  final String? status;
  final String? avatarUrl;
  final String? role;
  final List<RoleModel>? roles;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.displayName,
    this.phone,
    this.slug,
    this.status,
    this.avatarUrl,
    this.role,
    this.roles,
    this.createdAt,
    this.updatedAt,
  });

  /// Get display name with fallbacks
  String get name => displayName ?? fullName ?? email.split('@').first;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse roles - handle both List and String cases
    List<RoleModel>? rolesList;
    if (json['roles'] != null) {
      if (json['roles'] is List) {
        try {
          rolesList = (json['roles'] as List)
              .where((r) => r is Map<String, dynamic>) // Only process Map items
              .map((r) => RoleModel.fromJson(r as Map<String, dynamic>))
              .toList();
        } catch (e) {
          print("Error parsing roles: $e");
          rolesList = null;
        }
      } else if (json['roles'] is String) {
        // If roles is a string, ignore it (use the 'role' field instead)
        rolesList = null;
      }
    }
    
    return UserModel(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      fullName: json['full_name'] ?? json['name'],
      displayName: json['display_name'] ?? json['name'],
      phone: json['phone'],
      slug: json['slug'],
      status: json['status'],
      avatarUrl: json['avatar_url'] ?? json['avatar'],
      role: json['role'],
      roles: rolesList,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'display_name': displayName,
      'phone': phone,
      'slug': slug,
      'status': status,
      'avatar_url': avatarUrl,
      'role': role,
      'roles': roles?.map((r) => r.toJson()).toList(),
    };
  }

  /// Check if user has a specific role
  bool hasRole(String roleName) {
    return roles?.any((r) => r.roleName == roleName) ?? false;
  }

  /// Check if user is admin
  bool get isAdmin => hasRole('admin');

  /// Check if user is organization
  bool get isOrganization => hasRole('organization');

  /// Check if user is regular user
  bool get isUser => hasRole('user') || roles == null || roles!.isEmpty;

  /// Get primary role
  String get primaryRole {
    if (role != null && role!.isNotEmpty) return role!;
    if (isAdmin) return 'admin';
    if (isOrganization) return 'organization';
    return 'user';
  }
}
