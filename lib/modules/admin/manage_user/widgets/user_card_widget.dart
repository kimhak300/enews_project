import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/constants/app_widget_size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newshub/api/controller/user_controller.dart';

class UserCardWidget extends StatelessWidget {
  final int userId;
  final String displayName;
  final String email;
  final String role;
  final String avatarUrl;
  final VoidCallback? onDelete;

  const UserCardWidget({
    super.key,
    required this.userId,
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
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [

            /// Avatar (RECTANGLE with RADIUS + Transparent BG)
            ClipRRect(
              borderRadius: BorderRadius.circular(10), // Rectangle radius
              child: avatarUrl.isNotEmpty
                  ? Image.network(
                      AppConstants.STORAGE_BASE_URL + avatarUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _fallbackAvatar(theme);
                      },
                    )
                  : _fallbackAvatar(theme),
            ),

            const SizedBox(width: 16),

            /// User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.95)),
                  ),

                  const SizedBox(height: 6),

                  // Role tag
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: theme.colorScheme.primary.withOpacity(0.18)),
                    ),
                    child: Text(
                      role.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface.withOpacity(0.95),
                        fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) + 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Edit Button
            Container(
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.secondary.withOpacity(0.12),
              ),
              child: IconButton(
                icon: Icon(Icons.edit, color: theme.colorScheme.secondary, size: AppWidgetSize.iconSmall),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => UpdateUserBottomSheet(
                      userId: userId,
                      displayName: displayName,
                      email: email,
                      role: role,
                    ),
                  );
                },
              ),
            ),

            /// Delete Button
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.colorScheme.error.withOpacity(0.12),
              ),
              child: IconButton(
                icon: Icon(Icons.delete, color: theme.colorScheme.error, size: AppWidgetSize.iconSmall),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// FALLBACK AVATAR (Rectangle)
  Widget _fallbackAvatar(ThemeData theme) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          displayName[0].toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface.withOpacity(0.95),
          ),
        ),
      ),
    );
  }
}

/// Update User Bottom Sheet
class UpdateUserBottomSheet extends StatefulWidget {
  final int userId;
  final String displayName;
  final String email;
  final String role;

  const UpdateUserBottomSheet({
    super.key,
    required this.userId,
    required this.displayName,
    required this.email,
    required this.role,
  });

  @override
  State<UpdateUserBottomSheet> createState() => _UpdateUserBottomSheetState();
}

class _UpdateUserBottomSheetState extends State<UpdateUserBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  
  String _selectedRole = 'user';
  bool _isActive = true;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final UserController _userController = UserController();

  @override
  void initState() {
    super.initState();
    _displayNameController.text = widget.displayName;
    _emailController.text = widget.email;
    _selectedRole = widget.role;
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await _userController.updateUser(
      id: widget.userId,
      displayName: _displayNameController.text.trim(),
      email: _emailController.text.trim(),
      role: _selectedRole,
      isActive: _isActive,
      avatarFile: _imageFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Builder(builder: (ctx) {
                final theme = Theme.of(ctx);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'update_user'.tr,
                      style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withOpacity(0.95)),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: theme.iconTheme.color),
                      onPressed: () => Get.back(),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),

              // Profile Image
              Center(
                child: Builder(builder: (ctx) {
                  final theme = Theme.of(ctx);
                  return Stack(
                    children: [
                      // Improved avatar container for better contrast in dark mode
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _imageFile == null
                              ? theme.colorScheme.onSurface.withOpacity(0.08)
                              : Colors.transparent,
                          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.12)),
                        ),
                        child: ClipOval(
                          child: _imageFile != null
                              ? Image.file(
                                  _imageFile!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 48,
                                    color: theme.colorScheme.onSurface.withOpacity(0.95),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Material(
                          type: MaterialType.circle,
                          color: theme.colorScheme.primary,
                          elevation: 2,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _pickImage,
                            child: Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              child: Icon(Icons.camera_alt, size: 18, color: theme.colorScheme.onPrimary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Display Name
              Builder(builder: (ctx) {
                final theme = Theme.of(ctx);
                return TextFormField(
                  controller: _displayNameController,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
                  decoration: InputDecoration(
                    labelText: 'display_name'.tr,
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.primary)),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'please_enter_display_name'.tr;
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 16),

              // Email (Read-only for update)
              Builder(builder: (ctx) {
                final theme = Theme.of(ctx);
                return TextFormField(
                  controller: _emailController,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8)),
                  decoration: InputDecoration(
                    labelText: 'email'.tr,
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  ),
                  enabled: false,
                );
              }),
              const SizedBox(height: 16),

              // Role Dropdown
              Builder(builder: (ctx) {
                final theme = Theme.of(ctx);
                return DropdownButtonFormField<String>(
                  value: _selectedRole,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
                  dropdownColor: theme.colorScheme.surface,
                  iconEnabledColor: theme.colorScheme.onSurface.withOpacity(0.7),
                  decoration: InputDecoration(
                    labelText: 'select_role'.tr,
                    labelStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    border: const OutlineInputBorder(),
                    prefixIcon: Icon(Icons.badge, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.12))),
                  ),
                  items: [
                    DropdownMenuItem(value: 'user', child: Text('user'.tr, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)))),
                    DropdownMenuItem(value: 'organizer', child: Text('organizer'.tr, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)))),
                    DropdownMenuItem(value: 'admin', child: Text('admin'.tr, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)))),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedRole = value);
                    }
                  },
                );
              }),
              const SizedBox(height: 16),

              // Account Status
              Builder(builder: (ctx) {
                final theme = Theme.of(ctx);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('account_status'.tr, style: theme.textTheme.bodyMedium),
                    Row(
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: _isActive,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (value) => setState(() => _isActive = value!),
                        ),
                        Text('active'.tr, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.9))),
                        Radio<bool>(
                          value: false,
                          groupValue: _isActive,
                          activeColor: theme.colorScheme.primary,
                          onChanged: (value) => setState(() => _isActive = value!),
                        ),
                        Text('inactive'.tr, style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.9))),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),

              // Submit Button
              Builder(builder: (ctx) {
                final theme = Theme.of(ctx);
                return Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _userController.isLoading.value ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _userController.isLoading.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary)),
                            )
                          : Text('update_user'.tr, style: const TextStyle(fontSize: 16)),
                    ),
                  );
                });
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}