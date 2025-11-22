import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_spacing.dart';

class ProfileWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double avatarRadius;

  const ProfileWidget({
    super.key,
    this.imageUrl = '',
    required this.title,
    required this.description,
    this.avatarRadius = 50,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.paddingL),
          child: Column(
            children: [

              /// Avatar
              CircleAvatar(
                radius: avatarRadius + 4,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                child: CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: theme.colorScheme.surface,
                  backgroundImage: imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : null,
                  child: imageUrl.isEmpty
                      ? Icon(
                    Icons.person,
                    size: avatarRadius,
                    color: theme.colorScheme.primary,
                  ) : null,
                ),
              ),
              SizedBox(height: AppSpacing.paddingM),

              /// Name / Title
              Text(
                title,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              /// Description / Subtitle
              Text(
                description,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}