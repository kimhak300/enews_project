import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newshub/api/controller/user_controller.dart';
import 'package:newshub/app/constants/app_constant.dart';
import 'package:newshub/app/constants/app_widget_size.dart';
import 'package:image_picker/image_picker.dart';

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
    final UserController controller = Get.find();

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
                errorBuilder: (_, __, ___) => _fallbackAvatar(),
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
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Delete User',
                    middleText: 'Are you sure you want to delete this user?',
                    onConfirm: () async {
                      await controller.deleteUser(userId);
                      Get.back();
                    },
                    onCancel: () {},
                  );
                },
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
  final UserController controller = Get.find();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController roleController;
  File? avatarFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.displayName);
    emailController = TextEditingController(text: widget.email);
    roleController = TextEditingController(text: widget.role);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top bar
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Update User',
                style: theme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Display Name
              TextFormField(
                controller: nameController,
                decoration: _inputDecoration('Display Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: emailController,
                decoration: _inputDecoration('Email'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Role
              TextFormField(
                controller: roleController,
                decoration: _inputDecoration('Role'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Avatar Picker
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () async {
                      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (picked != null) {
                        setState(() => avatarFile = File(picked.path));
                      }
                    },
                    icon: const Icon(Icons.image),
                    label: const Text('Change Avatar'),
                  ),
                  const SizedBox(width: 12),
                  if (avatarFile != null)
                    const Text(
                      'Avatar Selected',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                ],
              ),

              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      await controller.updateUser(
                        id: widget.userId,
                        displayName: nameController.text.trim(),
                        email: emailController.text.trim(),
                        role: roleController.text.trim(),
                        isActive: true,
                        avatarFile: avatarFile,
                      );
                    }
                  },
                  child: Obx(
                        () => controller.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      'Update User',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}