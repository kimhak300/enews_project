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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
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
                  print('Error loading avatar: $error');
                  return _fallbackAvatar();
                },
              )
                  : _fallbackAvatar(),
            ),

            const SizedBox(width: 16),

            /// User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Role tag
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      role,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
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
                color: Colors.green.withOpacity(0.2),
              ),
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.green, size: AppWidgetSize.iconSmall),
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
                color: Colors.redAccent.withOpacity(0.2),
              ),
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent, size: AppWidgetSize.iconSmall),
                onPressed: onDelete,
              ),
            ),
          ],
        ),
      ),
    );
  }


  /// FALLBACK AVATAR (Rectangle)
  Widget _fallbackAvatar() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          displayName[0].toUpperCase(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update User',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : null,
                      child: _imageFile == null
                          ? Icon(Icons.person, size: 50, color: Colors.grey[400])
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: _pickImage,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Display Name
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Display Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter display name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email (Read-only for update)
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                enabled: false,
              ),
              const SizedBox(height: 16),

              // Role Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Select Role',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge),
                ),
                items: const [
                  DropdownMenuItem(value: 'user', child: Text('User')),
                  DropdownMenuItem(value: 'organizer', child: Text('Organizer')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedRole = value);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Account Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Account Status', style: TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _isActive,
                        onChanged: (value) => setState(() => _isActive = value!),
                      ),
                      const Text('Active'),
                      Radio<bool>(
                        value: false,
                        groupValue: _isActive,
                        onChanged: (value) => setState(() => _isActive = value!),
                      ),
                      const Text('Inactive'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Submit Button
              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _userController.isLoading.value ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _userController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Update User', style: TextStyle(fontSize: 16)),
                    ),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}