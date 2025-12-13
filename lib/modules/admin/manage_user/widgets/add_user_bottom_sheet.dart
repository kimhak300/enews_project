import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../../api/controller/user_controller.dart';

class AddUserBottomSheet extends StatefulWidget {
  const AddUserBottomSheet({super.key});

  @override
  State<AddUserBottomSheet> createState() => _AddUserBottomSheetState();
}

class _AddUserBottomSheetState extends State<AddUserBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  
  // Error states
  String? emailError;
  final bioController = TextEditingController();

  bool isActive = true;
  DateTime? createdAt;
  String? selectedRole;
  final List<String> roles = ['Admin', 'Organizer', 'User'];

  // Image File
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  // User Controller
  final UserController userController = Get.put(UserController());

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked != null) setState(() => createdAt = picked);
  }

  InputDecoration _input(String label, ThemeData theme) {
    return InputDecoration(
      labelText: label.tr,
      labelStyle: theme.inputDecorationTheme.labelStyle ?? TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.78)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.14))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: theme.colorScheme.primary)),
      filled: true,
      fillColor: theme.inputDecorationTheme.fillColor ?? theme.colorScheme.surfaceVariant,
    );
  }

  void _saveUser() async {
    // Clear previous errors
    setState(() => emailError = null);
    
    if (!_formKey.currentState!.validate()) return;
    if (selectedRole == null) {
      Get.snackbar('role_required'.tr, 'please_select_role'.tr);
      return;
    }

    try {
      await userController.createUser(
        displayName: displayNameController.text,
        email: emailController.text,
        password: passwordController.text,
        role: selectedRole!.toLowerCase(),
        isActive: isActive,
        avatarFile: imageFile,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      // Check if it's an email duplicate error
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      if (errorMsg.toLowerCase().contains('email') && 
          (errorMsg.toLowerCase().contains('taken') || 
           errorMsg.toLowerCase().contains('exists') ||
           errorMsg.toLowerCase().contains('already'))) {
        setState(() {
          emailError = errorMsg;
          _formKey.currentState!.validate(); // Trigger validation to show error
        });
      } else {
        // For other errors, show snackbar
        Get.snackbar('Error', errorMsg, snackPosition: SnackPosition.TOP);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Text('create_user'.tr, style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),

              // Profile Image Picker
              Text('profile_image'.tr, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Center(
                child: InkWell(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.6),
                    backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                    child: imageFile == null
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt, size: 32, color: theme.colorScheme.onSurface.withOpacity(0.7)),
                              const SizedBox(height: 8),
                              Text('tap_to_add'.tr, style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.9))),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Email
              TextFormField(
                controller: emailController,
                validator: (v) {
                  if (emailError != null) return emailError; // Show API error
                  if (v == null || v.isEmpty) return 'email_required'.tr;
                  if (!GetUtils.isEmail(v.trim())) return 'please_enter_valid_email'.tr;
                  return null;
                },
                onChanged: (v) {
                  // Clear email error when user types
                  if (emailError != null) {
                    setState(() => emailError = null);
                  }
                },
                decoration: _input('email'.tr, theme).copyWith(
                  prefixIcon: Icon(Icons.email, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
                keyboardType: TextInputType.emailAddress,
                style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
              ),
              const SizedBox(height: 12),

              // Password
              TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'password_required'.tr;
                  if (v.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
                decoration: _input('password'.tr, theme).copyWith(
                  prefixIcon: Icon(Icons.lock, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
                style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
              ),
              const SizedBox(height: 12),

              // Display Name
              TextFormField(
                controller: displayNameController,
                validator: (v) => (v == null || v.isEmpty) ? 'display_name_required'.tr : null,
                decoration: _input('display_name'.tr, theme).copyWith(
                  prefixIcon: Icon(Icons.person, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
                style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
              ),
              const SizedBox(height: 12),

              // Account Status
              Text('account_status'.tr, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<bool>(value: true, groupValue: isActive, activeColor: theme.colorScheme.primary, onChanged: (v) => setState(() => isActive = v ?? true)),
                  Text('active'.tr, style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95))),
                  Radio<bool>(value: false, groupValue: isActive, activeColor: theme.colorScheme.primary, onChanged: (v) => setState(() => isActive = v ?? false)),
                  Text('inactive'.tr, style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95))),
                ],
              ),
              const SizedBox(height: 8),

              // Role Dropdown
              DropdownButtonFormField<String>(
                decoration: _input('select_role'.tr, theme),
                value: selectedRole,
                dropdownColor: theme.colorScheme.surface,
                style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95)),
                iconEnabledColor: theme.colorScheme.onSurface.withOpacity(0.7),
                items: roles.map((role) => DropdownMenuItem(value: role, child: Text(role.tr, style: textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.95))))).toList(),
                onChanged: (value) => setState(() => selectedRole = value),
              ),
              const SizedBox(height: 18),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: theme.colorScheme.primary,
                    ),
                    onPressed: userController.isLoading.value ? null : _saveUser,
                    child: userController.isLoading.value
                        ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: theme.colorScheme.onPrimary, strokeWidth: 2))
                        : Text('save_user'.tr, style: textTheme.titleMedium?.copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                  );
                }),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}