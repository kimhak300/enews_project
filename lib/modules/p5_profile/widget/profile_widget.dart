import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_spacing.dart';

class ProfileWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double avatarRadius;
  final List<Color>? gradientColors;

  const ProfileWidget({
    super.key,
    this.imageUrl = '',
    required this.title,
    required this.description,
    this.avatarRadius = 50,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = gradientColors ??
        [
          theme.colorScheme.primary.withOpacity(0.8),
          theme.colorScheme.primary.withOpacity(0.4),
        ];

    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            children: [

              /// Avatar
              CircleAvatar(
                radius: avatarRadius + 4,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: theme.colorScheme.surface,
                  backgroundImage:
                  imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty
                      ? Icon(
                    Icons.person,
                    size: avatarRadius,
                    color: theme.colorScheme.primary,
                  )
                      : null,
                ),
              ),
              SizedBox(height: AppSpacing.paddingM),

              /// Name / Title
              Text(
                title,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),

              /// Description / Subtitle
              Text(
                description,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.white.withOpacity(0.8)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}