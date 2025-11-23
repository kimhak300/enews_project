class FollowModel {
  int? followId;
  int followerId;
  int followingId;
  String createdAt;

  FollowModel({
    this.followId,
    required this.followerId,
    required this.followingId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'follow_id': followId,
      'follower_id': followerId,
      'following_id': followingId,
      'created_at': createdAt,
    };
  }

  factory FollowModel.fromMap(Map<String, dynamic> map) {
    return FollowModel(
      followId: map['follow_id'],
      followerId: map['follower_id'],
      followingId: map['following_id'],
      createdAt: map['created_at'],
    );
  }
}