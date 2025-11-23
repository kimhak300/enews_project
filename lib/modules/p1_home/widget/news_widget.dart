import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/controllers/id_controller.dart';
import 'package:newshub/app/constants/app_colors.dart';
import 'package:newshub/sqflite_db/controller/follow_controller.dart';

class NewsWidget extends StatelessWidget {
  final String username;
  final String time;
  final String caption;
  final String imageUrl;
  final int authorId;
  final int likeCount;
  final int commentCount;
  final int followCount;

  NewsWidget({
    super.key,
    required this.username,
    required this.time,
    required this.caption,
    required this.imageUrl,
    required this.authorId,
    this.likeCount = 0,
    this.commentCount = 0,
    this.followCount = 0,
  });

  final FollowController followController = Get.find();
  final IdController idController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isMine = idController.currentUserId.value == authorId;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row: Logo, Username + Time, Options
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?u=$username',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      time,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              /// Options: Edit/Delete for own posts
              if (isMine)
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_horiz,
                      color: theme.colorScheme.onSurface),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.defaultDialog(
                        title: 'Edit Post',
                        middleText: 'Are you sure you want to edit this post?',
                        onConfirm: () {
                          print('Edit confirmed for $authorId');
                          Get.back();
                        },
                        onCancel: () {},
                      );
                    } else if (value == 'delete') {
                      Get.defaultDialog(
                        title: 'Delete Post',
                        middleText: 'Are you sure you want to delete this post?',
                        onConfirm: () {
                          print('Delete confirmed for $authorId');
                          Get.back();
                        },
                        onCancel: () {},
                      );
                    }
                  },
                ),
            ],
          ),

          const SizedBox(height: 12),

          /// Caption
          Text(
            caption,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),

          /// Image
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          const SizedBox(height: 12),

          /// Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /// Own post: counts only (non-clickable)
              if (isMine) ...[
                _CountIcon(icon: Icons.thumb_up_alt_outlined),
                _CountIcon(icon: Icons.comment_outlined),
                _CountIcon(icon: Icons.person_add_alt_1_outlined),
              ]
              else ...[
                _InteractiveIcon(
                  icon: Icons.thumb_up_alt_outlined,
                  onTap: () => Get.snackbar('Like', 'You liked the post'),
                ),
                _InteractiveIcon(
                  icon: Icons.comment_outlined,
                  onTap: () => Get.snackbar('Comment', 'Comment tapped'),
                ),
                Obx(() {
                  final isFollowing = followController.followingAuthors.contains(authorId);
                  return _InteractiveIcon(
                    icon: Icons.person_add_alt_1_outlined,
                    onTap: () => followController.toggleFollow(authorId),
                    isActive: isFollowing,
                  );
                }),
              ],
            ],
          )
        ],
      ),
    );
  }
}

/// Non-clickable grey icon
class _CountIcon extends StatelessWidget {
  final IconData icon;
  const _CountIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 24, color: Colors.grey);
  }
}

/// Clickable icon, changes color when active
class _InteractiveIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _InteractiveIcon({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Icon(
        icon,
        size: 24,
        color: isActive ? AppColors.primary : Colors.grey,
      ),
    );
  }
}