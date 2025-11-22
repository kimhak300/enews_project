import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_colors.dart';

class NewsWidget extends StatelessWidget {
  final String username;
  final String time;
  final String caption;
  final String imageUrl;

  const NewsWidget({
    super.key,
    required this.username,
    required this.time,
    required this.caption,
    required this.imageUrl,
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
          /// Top Row: Logo, Username + Time, DropDown
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Logo
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?u=$username',
                ),
              ),
              const SizedBox(width: 12),

              /// Username & Time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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

              /// Drop Down / Options
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, color: theme.colorScheme.onSurface),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  const PopupMenuItem(value: 'report', child: Text('Report')),
                ],
                onSelected: (value) {
                  Get.snackbar('Action', 'Selected: $value');
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),

          /// Actions Row: Like, Comment, Share
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                icon: Icons.thumb_up_alt_outlined,
                label: 'Like',
                onTap: () => Get.snackbar('Like', 'You liked the post'),
              ),
              _ActionButton(
                icon: Icons.comment_outlined,
                label: 'Comment',
                onTap: () => Get.snackbar('Comment', 'Comment tapped'),
              ),
              _ActionButton(
                icon: Icons.share_outlined,
                label: 'Share',
                onTap: () => Get.snackbar('Share', 'Share tapped'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual Action Button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}