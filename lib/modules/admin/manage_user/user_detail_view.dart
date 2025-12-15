import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_constant.dart';
// Using theme colors from Theme.of(context)
import 'package:newshub/modules/admin/manage_user/user_detail_controller.dart';
import 'dart:convert';
import 'dart:io';

class UserDetailView extends GetView<UserDetailController> {
  const UserDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('user_details'.tr),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.refresh,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.refresh,
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        final user = controller.user.value;
        if (user == null) {
          return Center(child: Text('user_not_found'.tr));
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header with gradient background
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    // Avatar
                    _buildAvatar(user.avatarUrl, theme),
                    const SizedBox(height: 16),
                    
                    // Display Name
                    Text(
                      user.displayName ?? user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    if (user.fullName != null && user.fullName != user.displayName) ...[
                      const SizedBox(height: 4),
                      Text(
                        user.fullName!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    
                    const SizedBox(height: 12),
                    
                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getRoleIcon(user.primaryRole),
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            controller.getRoleDisplayName(user.primaryRole),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // User Information Cards
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Information Section
                    Text(
                      'account_information'.tr,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Email
                    _buildInfoCard(
                      theme: theme,
                      icon: Icons.email_outlined,
                      label: 'email'.tr,
                      value: user.email,
                      iconColor: Colors.blue,
                    ),

                    const SizedBox(height: 12),

                    // Phone (if available)
                    if (user.phone != null && user.phone!.isNotEmpty)
                      _buildInfoCard(
                        theme: theme,
                        icon: Icons.phone_outlined,
                        label: 'phone'.tr,
                        value: user.phone!,
                        iconColor: Colors.green,
                      ),

                    if (user.phone != null && user.phone!.isNotEmpty)
                      const SizedBox(height: 12),

                    // Account Status
                    _buildInfoCard(
                      theme: theme,
                      icon: Icons.verified_user_outlined,
                      label: 'account_status'.tr,
                      value: controller.getStatusDisplayName(user.status),
                      iconColor: _getStatusColor(user.status),
                      valueColor: _getStatusColor(user.status),
                    ),

                    const SizedBox(height: 12),

                    // Role
                    _buildInfoCard(
                      theme: theme,
                      icon: Icons.badge_outlined,
                      label: 'role'.tr,
                      value: controller.getRoleDisplayName(user.primaryRole),
                      iconColor: theme.colorScheme.primary,
                    ),

                    const SizedBox(height: 24),

                    // Additional Information Section
                    Text(
                      'additional_information'.tr,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // User ID
                    _buildInfoCard(
                      theme: theme,
                      icon: Icons.fingerprint,
                      label: 'user_id'.tr,
                      value: '#${user.id}',
                      iconColor: Colors.grey,
                    ),

                    const SizedBox(height: 12),

                    // Created At
                    if (user.createdAt != null)
                      _buildInfoCard(
                        theme: theme,
                        icon: Icons.calendar_today_outlined,
                        label: 'member_since'.tr,
                        value: _formatDate(user.createdAt!),
                        iconColor: Colors.orange,
                      ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAvatar(String? avatarUrl, ThemeData theme) {
    ImageProvider? avatarProvider;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      if (avatarUrl.startsWith('data:image')) {
        try {
          final bytes = base64Decode(avatarUrl.split(',').last);
          avatarProvider = MemoryImage(bytes);
        } catch (_) {
          avatarProvider = null;
        }
      } else {
        String candidate = avatarUrl;
        if (candidate.startsWith('file://')) {
          candidate = candidate.replaceFirst('file://', '');
        }
        
        try {
          final file = File(candidate);
          if (file.existsSync()) {
            avatarProvider = FileImage(file);
          }
        } catch (_) {
          avatarProvider = null;
        }

        if (avatarProvider == null) {
          String url = candidate;
          if (!url.startsWith('http://') && !url.startsWith('https://')) {
            url = '${AppConstants.STORAGE_BASE_URL}${candidate.startsWith('/') ? candidate : '/$candidate'}';
          }
          avatarProvider = NetworkImage(url);
        }
      }
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
          child: CircleAvatar(
        radius: 58,
        backgroundColor: Colors.white,
        backgroundImage: avatarProvider,
        child: avatarProvider == null
            ? Icon(
                Icons.person,
                size: 60,
                color: theme.colorScheme.primary,
              )
            : null,
      ),
    );
  }

  Widget _buildInfoCard({
    required ThemeData theme,
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getRoleIcon(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'organizer':
      case 'organization':
        return Icons.business;
      case 'user':
      default:
        return Icons.person;
    }
  }

  Color _getStatusColor(String? status) {
    if (status == null || status.isEmpty) return Colors.green;
    
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'inactive':
        return Colors.orange;
      case 'banned':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'january', 'february', 'march', 'april', 'may', 'june',
      'july', 'august', 'september', 'october', 'november', 'december'
    ];
    
    return '${date.day} ${months[date.month - 1].tr} ${date.year}';
  }
}
