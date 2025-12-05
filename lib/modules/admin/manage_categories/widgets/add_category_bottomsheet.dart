import 'package:flutter/material.dart';

class AddCategoryBottomsheet extends StatefulWidget {
  const AddCategoryBottomsheet({super.key});

  @override
  State<AddCategoryBottomsheet> createState() => _AddCategoryBottomsheetState();
}

class _AddCategoryBottomsheetState extends State<AddCategoryBottomsheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final slugController = TextEditingController();
  final descriptionController = TextEditingController();

  // Data
  String? selectedParent;
  List<String> parentCategories = ["None", "Technology", "Business", "Sports"];

  DateTime? createdAt;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery
            .of(context)
            .viewInsets
            .bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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
                "Create Category",
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Parent Category
              DropdownButtonFormField<String>(
                decoration: _input("Parent Category"),
                value: selectedParent,
                items: parentCategories.map((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(item, style: textTheme.bodyMedium),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedParent = value),
              ),
              const SizedBox(height: 16),

              // Category Name
              TextFormField(
                controller: nameController,
                decoration: _input("Category Name"),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Slug
              TextFormField(
                controller: slugController,
                decoration: _input("Slug"),
                validator: (v) =>
                v == null || v.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: _input("Description"),
              ),
              const SizedBox(height: 16),

              // Created At
              Text(
                "Created At",
                style: textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        createdAt == null
                            ? "Select date"
                            : "${createdAt!.year}-${createdAt!
                            .month}-${createdAt!.day}",
                        style: textTheme.bodyMedium,
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // TODO: Save category data
                    }
                  },
                  child: Text(
                    "Save Category",
                    style: textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
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
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}