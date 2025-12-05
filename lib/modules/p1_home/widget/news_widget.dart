import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:newshub/app/constants/app_widget_size.dart';
import 'package:newshub/app/constants/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?img=$authorId")),
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
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        )),
                  ],
                ),
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
            children: const [
              _IconWithCount(
                icon: Icons.thumb_up_alt_outlined,
                count: 0,
                isActive: false,
                isClickable: false,
              ),
              _IconWithCount(
                icon: Icons.bookmark_outline,
                count: 0,
                isActive: false,
                isClickable: false,
              ),
              _IconWithCount(
                icon: Icons.person_add_alt_1_outlined,
                count: 0,
                isActive: false,
                isClickable: false,
              ),
            ],
          ),
        ],
      ),
    );
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