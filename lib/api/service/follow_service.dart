import 'package:get/get.dart';
import 'package:newshub/app/services/api_service.dart';

/// Service to handle user follow/unfollow operations
class FollowService {
  final ApiService _apiService = Get.find<ApiService>();

  /// Check if the current user is following a specific user
  Future<bool> checkIfFollowing(int userId) async {
    try {
      final response = await _apiService.checkFollowStatus(userId);
      if (response.isSuccess) {
        return response.data['is_following'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking follow status: $e');
      return false;
    }
  }

  /// Follow a user (admin, organizer, or regular user)
  /// Returns true if successful, false otherwise
  Future<bool> followUser(int userId) async {
    try {
      final response = await _apiService.followUser(userId);
      if (response.isSuccess) {
        print('Successfully followed user $userId');
        // Backend response includes followed_user.role for analytics
        final followedUser = response.data['followed_user'];
        if (followedUser != null) {
          print('Followed user role: ${followedUser['role']}');
        }
        return true;
      } else {
        print('Failed to follow user: ${response.error}');
        return false;
      }
    } catch (e) {
      print('Error following user: $e');
      return false;
    }
  }

  /// Unfollow a user
  /// Returns true if successful, false otherwise
  Future<bool> unfollowUser(int userId) async {
    try {
      final response = await _apiService.unfollowUser(userId);
      if (response.isSuccess) {
        print('Successfully unfollowed user $userId');
        // Backend response includes unfollowed_user.role for analytics
        final unfollowedUser = response.data['unfollowed_user'];
        if (unfollowedUser != null) {
          print('Unfollowed user role: ${unfollowedUser['role']}');
        }
        return true;
      } else {
        print('Failed to unfollow user: ${response.error}');
        return false;
      }
    } catch (e) {
      print('Error unfollowing user: $e');
      return false;
    }
  }

  /// Get the list of followers for a user
  Future<List<dynamic>> getFollowers(int userId) async {
    try {
      final response = await _apiService.getFollowers(userId);
      if (response.isSuccess) {
        return response.data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting followers: $e');
      return [];
    }
  }

  /// Get the list of users that a user is following
  Future<List<dynamic>> getFollowing(int userId) async {
    try {
      final response = await _apiService.getFollowing(userId);
      if (response.isSuccess) {
        return response.data['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error getting following: $e');
      return [];
    }
  }
}
