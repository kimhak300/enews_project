import '../local/storage_service.dart';

class AuthService {
  final StorageService _storage = StorageService();
  
  // Storage keys
  static const String _usersKey = 'registered_users';
  static const String _currentUserKey = 'current_user';
  
  // Get all registered users
  List<Map<String, dynamic>> getRegisteredUsers() {
    final users = _storage.read<List>(_usersKey);
    if (users == null) return [];
    return List<Map<String, dynamic>>.from(users);
  }
  
  // Check if email already exists
  bool emailExists(String email) {
    final users = getRegisteredUsers();
    return users.any((user) => 
        user['email'].toString().toLowerCase() == email.toLowerCase());
  }
  
  // Register new user
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (emailExists(email)) {
      return false;
    }
    
    final users = getRegisteredUsers();
    users.add({
      'name': name,
      'email': email.toLowerCase(),
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
    });
    
    await _storage.write(_usersKey, users);
    return true;
  }
  
  // Validate login credentials
  Map<String, dynamic>? validateLogin({
    required String email,
    required String password,
  }) {
    final users = getRegisteredUsers();
    
    try {
      final user = users.firstWhere(
        (user) => user['email'].toString().toLowerCase() == email.toLowerCase() && 
                  user['password'] == password,
      );
      return user;
    } catch (e) {
      return null;
    }
  }
  
  // Save current logged in user
  Future<void> saveCurrentUser(Map<String, dynamic> user) async {
    await _storage.write(_currentUserKey, user);
  }
  
  // Get current user
  Map<String, dynamic>? getCurrentUser() {
    return _storage.read<Map<String, dynamic>>(_currentUserKey);
  }
  
  // Logout
  Future<void> logout() async {
    await _storage.remove(_currentUserKey);
  }
  
  // Check if user is logged in
  bool isLoggedIn() {
    return getCurrentUser() != null;
  }
}
