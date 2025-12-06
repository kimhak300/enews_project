import 'package:flutter/material.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/constants/app_widget_size.dart';

class UserCardWidget extends StatelessWidget {
  final String displayName;
  final String email;
  final String role;
  final String avatarUrl;
  final VoidCallback? onDelete;

  const UserCardWidget({
    super.key,
    required this.displayName,
    required this.email,
    required this.role,
    this.avatarUrl = '',
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 24,
              backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(AppConstants.STORAGE_BASE_URL+avatarUrl) : null,
              child: avatarUrl.isEmpty ? Text(displayName[0], style: theme.textTheme.titleMedium) : null,
            ),
            const SizedBox(width: 16),

            // Name, Email, Role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    email,
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      role,
                      style: theme.textTheme.bodySmall?.copyWith(
                        // color: Colors.blueAccent.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Delete Button
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent.withOpacity(0.2),
              ),
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent, size: AppWidgetSize.iconSmall),
                onPressed: onDelete,
                tooltip: 'Delete User',
              ),
            ),
          ],
        ),
      ),
    );
  }
}