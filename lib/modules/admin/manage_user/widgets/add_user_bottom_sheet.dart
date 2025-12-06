import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import '../../../../api/controller/user_controller.dart';

class AddUserBottomSheet extends StatefulWidget {
  const AddUserBottomSheet({super.key});

  @override
  State<AddUserBottomSheet> createState() => AddUserBottomSheetState();
}

class AddUserBottomSheetState extends State<AddUserBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final displayNameController = TextEditingController();
  final bioController = TextEditingController();

  bool isActive = true;
  DateTime? createdAt;
  String? selectedRole;
  List<String> roles = ["Admin", "Organizer", "User"];

  // Image File
  File? imageFile;
  final ImagePicker _picker = ImagePicker();

  // User Controller
  final UserController userController = Get.put(UserController());

  Future<void> pickImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);

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

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey.shade100,
    );
  }

  void _saveUser() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedRole == null) {
      Get.snackbar("Role Required", "Please select a role");
      return;
    }

    await userController.createUser(
      displayName: displayNameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: selectedRole!.toLowerCase(),
      isActive: isActive,
      avatarFile: imageFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Text(
            "Create User",
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // Profile Image Picker
          Text(
            "Profile Image",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Center(
            child: InkWell(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                imageFile != null ? FileImage(imageFile!) : null,
                child: imageFile == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt,
                        size: 35, color: Colors.grey),
                    const SizedBox(height: 6),
                    Text(
                      "Tap to add",
                      style: textTheme.bodyMedium,
                    )
                  ],
                )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Email
          TextFormField(
            controller: emailController,
            validator: (v) =>
            (v == null || v.isEmpty) ? "Email is required" : null,
            decoration: _input("Email"),
          ),
          const SizedBox(height: 16),

          // Password
          TextFormField(
            controller: passwordController,
            obscureText: true,
            validator: (v) =>
            (v == null || v.isEmpty) ? "Password is required" : null,
            decoration: _input("Password"),
          ),
          const SizedBox(height: 16),

          // Display Name
          TextFormField(
            controller: displayNameController,
            validator: (v) =>
            (v == null || v.isEmpty) ? "Display name is required" : null,
            decoration: _input("Display Name"),
          ),
          const SizedBox(height: 16),

          // Account Status
          Text(
            "Account Status",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Radio(
                value: true,
                groupValue: isActive,
                onChanged: (v) => setState(() => isActive = v!),
              ),
              Text("Active", style: textTheme.bodyMedium),
              Radio(
                value: false,
                groupValue: isActive,
                onChanged: (v) => setState(() => isActive = v!),
              ),
              Text("Inactive", style: textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 16),

          // Role Dropdown
          DropdownButtonFormField<String>(
            decoration: _input("Select Role"),
            value: selectedRole,
            items: roles.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(role, style: textTheme.bodyMedium),
              );
            }).toList(),
            onChanged: (value) => setState(() => selectedRole = value),
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: userController.isLoading.value ? null : _saveUser,
                child: userController.isLoading.value
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  "Save User",
                  style: textTheme.titleMedium?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            }),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}