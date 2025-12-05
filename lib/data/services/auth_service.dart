// // import '../local/storage_service.dart';
//
// // class AuthService {
// //   final StorageService _storage = StorageService();
//
// //   // Storage keys
// //   static const String _usersKey = 'registered_users';
// //   static const String _currentUserKey = 'current_user';
//
// //   // Get all registered users
// //   List<Map<String, dynamic>> getRegisteredUsers() {
// //     final users = _storage.read<List>(_usersKey);
// //     if (users == null) return [];
// //     return List<Map<String, dynamic>>.from(users);
// //   }
//
// //   // Check if email already exists
// //   bool emailExists(String email) {
// //     final users = getRegisteredUsers();
// //     return users.any((user) =>
// //         user['email'].toString().toLowerCase() == email.toLowerCase());
// //   }
//
// //   // Register new user
// //   Future<bool> registerUser({
// //     required String name,
// //     required String email,
// //     required String password,
// //   }) async {
// //     if (emailExists(email)) {
// //       return false;
// //     }
//
// //     final users = getRegisteredUsers();
// //     users.add({
// //       'name': name,
// //       'email': email.toLowerCase(),
// //       'password': password,
// //       'created_at': DateTime.now().toIso8601String(),
// //     });
//
// //     await _storage.write(_usersKey, users);
// //     return true;
// //   }
//
// //   // Validate login credentials
// //   Map<String, dynamic>? validateLogin({
// //     required String email,
// //     required String password,
// //   }) {
// //     final users = getRegisteredUsers();
//
// //     try {
// //       final user = users.firstWhere(
// //         (user) => user['email'].toString().toLowerCase() == email.toLowerCase() &&
// //                   user['password'] == password,
// //       );
// //       return user;
// //     } catch (e) {
// //       return null;
// //     }
// //   }
//
// //   // Save current logged in user
// //   Future<void> saveCurrentUser(Map<String, dynamic> user) async {
// //     await _storage.write(_currentUserKey, user);
// //   }
//
// //   // Get current user
// //   Map<String, dynamic>? getCurrentUser() {
// //     return _storage.read<Map<String, dynamic>>(_currentUserKey);
// //   }
//
// //   // Logout
// //   Future<void> logout() async {
// //     await _storage.remove(_currentUserKey);
// //   }
//
// //   // Check if user is logged in
// //   bool isLoggedIn() {
// //     return getCurrentUser() != null;
// //   }
// // }
//
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import '../models/user_model.dart';
// import '../models/auth_response_model.dart';
// import '../../app/config/api_constants.dart';
// import 'api_service.dart';
//
// class AuthService {
//   final ApiService _apiService = ApiService();
//   final _storage = const FlutterSecureStorage();
//
//   // Login
//   Future<AuthResponseModel> login({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       final response = await _apiService.post(
//         ApiConstants.login,
//         data: {
//           'email': email,
//           'password': password,
//         },
//       );
//
//       final authResponse = AuthResponseModel.fromJson(response.data);
//
//       // Save token and user
//       await _apiService.saveToken(authResponse.token);
//       await _saveUser(authResponse.user);
//
//       return authResponse;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Register
//   Future<AuthResponseModel> register({
//     required String name,
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//   }) async {
//     try {
//       final response = await _apiService.post(
//         ApiConstants.register,
//         data: {
//           'name': name,
//           'email': email,
//           'password': password,
//           'password_confirmation': passwordConfirmation,
//         },
//       );
//
//       final authResponse = AuthResponseModel.fromJson(response.data);
//
//       // Save token and user
//       await _apiService.saveToken(authResponse.token);
//       await _saveUser(authResponse.user);
//
//       return authResponse;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Logout
//   Future<void> logout() async {
//     try {
//       await _apiService.post(ApiConstants.logout);
//       await _apiService.clearAuth();
//     } catch (e) {
//       // Even if API call fails, clear local auth
//       await _apiService.clearAuth();
//       rethrow;
//     }
//   }
//
//   // Get Current User
//   Future<UserModel> getCurrentUser() async {
//     try {
//       final response = await _apiService.get(ApiConstants.me);
//       final user = UserModel.fromJson(response.data['user']);
//       await _saveUser(user);
//       return user;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Update Profile
//   Future<UserModel> updateProfile({
//     String? name,
//     String? email,
//     String? phone,
//   }) async {
//     try {
//       final response = await _apiService.put(
//         ApiConstants.updateProfile,
//         data: {
//           if (name != null) 'name': name,
//           if (email != null) 'email': email,
//           if (phone != null) 'phone': phone,
//         },
//       );
//
//       final user = UserModel.fromJson(response.data['user']);
//       await _saveUser(user);
//       return user;
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   // Check if logged in
//   Future<bool> isLoggedIn() async {
//     final token = await _apiService.getToken();
//     return token != null;
//   }
//
//   // Get saved user
//   Future<UserModel?> getSavedUser() async {
//     try {
//       final userJson = await _storage.read(key: ApiConstants.userKey);
//       if (userJson != null) {
//         return UserModel.fromJson(jsonDecode(userJson));
//       }
//       return null;
//     } catch (e) {
//       return null;
//     }
//   }
//
//   // Save user to storage
//   Future<void> _saveUser(UserModel user) async {
//     await _storage.write(
//       key: ApiConstants.userKey,
//       value: jsonEncode(user.toJson()),
//     );
//   }
// }
