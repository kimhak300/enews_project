import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_widget_size.dart';
import 'package:newshub/app/constants/app_colors.dart';
import 'package:newshub/app/controllers/id_controller.dart';
import 'package:newshub/sqflite_db/controller/follow_controller.dart';
import 'package:newshub/sqflite_db/controller/like_controller.dart';
import 'package:newshub/sqflite_db/controller/user_controller.dart';
import 'package:newshub/sqflite_db/controller/bookmark_controller.dart';
import 'package:video_player/video_player.dart';

class NewsWidget extends StatelessWidget {
  final String username;
  final String time;
  final String caption;
  final String mediaUrl;
  final int authorId;
  final int articleId;

  NewsWidget({
    super.key,
    required this.username,
    required this.time,
    required this.caption,
    required this.mediaUrl,
    required this.authorId,
    required this.articleId,
  });

  final FollowController followController = Get.find();
  final IdController idController = Get.find();
  final UserController userController = Get.find();
  final BookmarkController bookmarkController = Get.find();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isMine = idController.currentUserId.value == authorId;
    final currentUserId = idController.currentUserId.value;

    final likeController = Get.put(
      LikeController(),
      tag: 'like_$articleId',
    );

    likeController.loadLikeStatus(currentUserId, articleId);
    if (!isMine) followController.loadFollowersCount(authorId);
    userController.loadUserById(authorId);

    return Obx(() {
      final user = userController.userMap[authorId];
      final profileImg = (user != null && user.profileImage != null)
          ? user.profileImage!
          : "https://i.pravatar.cc/150?img=$authorId";

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
            /// TOP SECTION — Avatar + Username + Time
            Row(
              children: [
                CircleAvatar(radius: 20, backgroundImage: NetworkImage(profileImg)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(time,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color:
                            theme.colorScheme.onSurface.withOpacity(0.6),
                          )),
                    ],
                  ),
                ),
                if (isMine)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_horiz,
                        color: theme.colorScheme.onSurface),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                    onSelected: (value) {},
                  ),
              ],
            ),
            const SizedBox(height: 12),

            /// CAPTION
            Text(caption, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),

            /// MEDIA
            if (mediaUrl.isNotEmpty) _MediaWidget(url: mediaUrl),
            const SizedBox(height: 12),

            /// ACTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                /// LIKE (keep as before)
                Obx(() {
                  return _IconWithCount(
                    icon: Icons.thumb_up_alt_outlined,
                    count: likeController.likeCount.value,
                    isActive: likeController.isLiked.value,
                    isClickable: !isMine,
                    onTap: () => !isMine
                        ? likeController.toggleLike(currentUserId, articleId)
                        : null,
                  );
                }),

                /// BOOKMARK
                Obx(() {
                  final isBookmarked = bookmarkController.isBookmarked(articleId);
                  final count = bookmarkController.getBookmarkCountRx(articleId);

                  return Row(
                    children: [
                      if (!isMine)
                        InkWell(
                          onTap: () => bookmarkController.toggleBookmark(articleId),
                          child: Icon(
                            isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                            color: isBookmarked ? Colors.blue : Colors.grey,
                          ),
                        )
                      else
                        Icon(Icons.bookmark_outline, color: Colors.grey),
                      const SizedBox(width: 4),
                      Obx(() => Text(count.value.toString())),
                    ],
                  );
                }),

                /// FOLLOW
                Obx(() {
                  final isFollowing = followController.isFollowing(authorId);
                  final count = followController.getFollowersCountRx(authorId);

                  return Row(
                    children: [
                      if (!isMine)
                        InkWell(
                          onTap: () => followController.toggleFollow(authorId),
                          child: Icon(
                            isFollowing
                                ? Icons.person
                                : Icons.person_add_alt_1_outlined,
                            color: isFollowing ? Colors.green : Colors.grey,
                          ),
                        )
                      else
                        Icon(Icons.person_add_alt_1_outlined, color: Colors.grey),
                      const SizedBox(width: 4),
                      Obx(() => Text(count.value.toString())),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      );
    });
  }
}

/// MEDIA WIDGET
class _MediaWidget extends StatefulWidget {
  final String url;
  const _MediaWidget({required this.url});

  @override
  State<_MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<_MediaWidget> {
  VideoPlayerController? _videoController;
  bool isVideo = false;

  @override
  void initState() {
    super.initState();
    isVideo = widget.url.endsWith('.mp4') || widget.url.endsWith('.mov');

    if (isVideo) {
      _videoController = VideoPlayerController.network(widget.url)
        ..initialize().then((_) {
          setState(() {});
          _videoController!.setLooping(true);
          _videoController!.play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isVideo &&
        _videoController != null &&
        _videoController!.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      );
    } else if (!isVideo) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          widget.url,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}

/// ICON + COUNT
class _IconWithCount extends StatelessWidget {
  final IconData icon;
  final int? count;
  final bool isActive;
  final bool isClickable;
  final VoidCallback? onTap;

  const _IconWithCount({
    required this.icon,
    this.count,
    this.isActive = false,
    this.isClickable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isClickable ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Icon(icon,
              size: AppWidgetSize.iconSmall,
              color: isActive ? AppColors.primary : Colors.grey),
          if (count != null && count! > 0) ...[
            const SizedBox(width: 4),
            Text(count.toString()),
          ],
        ],
      ),
    );
  }
}