import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateArticleBottomSheet extends StatefulWidget {
  const CreateArticleBottomSheet({super.key});

  @override
  State<CreateArticleBottomSheet> createState() =>
      _CreateArticleBottomSheetState();
}

class _CreateArticleBottomSheetState extends State<CreateArticleBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final slugController = TextEditingController();
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final excerptController = TextEditingController();
  final contentController = TextEditingController();
  final languageController = TextEditingController(text: "en");

  // Dropdown Data
  String? selectedStatus;
  String? selectedAuthor;

  List<String> statusList = ["draft", "published", "archived"];
  List<String> authors = ["Admin 1", "Editor", "Guest"];

  // Multi Select
  List<String> categories = ["Tech", "Business", "Education", "Sports"];
  List<String> selectedCategories = [];

  List<String> tags = ["Flutter", "AI", "Trending", "Backend"];
  List<String> selectedTags = [];

  // Date fields
  DateTime? publishedAt;
  DateTime? createdAt = DateTime.now();
  DateTime? updatedAt = DateTime.now();

  // Feature Image
  File? imageFile;
  final ImagePicker picker = ImagePicker();

  bool isFeatured = false;

  Future pickImage() async {
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => imageFile = File(file.path));
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /* --------------------- TOP BAR (Drag + Title + Cancel) -------------------- */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Create Article",
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Cancel Button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, size: 26, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),

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

              /* ---------------------------- FEATURE IMAGE ---------------------------- */
              Text("Feature Image",
                  style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              InkWell(
                onTap: pickImage,
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.grey.shade100,
                  ),
                  child: imageFile == null
                      ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_a_photo, size: 40),
                        const SizedBox(height: 6),
                        Text("Tap to upload image",
                            style: text.bodyMedium),
                      ],
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(imageFile!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /* ------------------------------- FORM FIELDS ------------------------------- */
              _field("Slug", slugController, text, required: true),
              const SizedBox(height: 16),

              _field("Title", titleController, text, required: true),
              const SizedBox(height: 16),

              _field("Subtitle", subtitleController, text),
              const SizedBox(height: 16),

              _field("Excerpt", excerptController, text, maxLines: 2),
              const SizedBox(height: 16),

              _field("Content (HTML)", contentController, text,
                  required: true, maxLines: 5),
              const SizedBox(height: 16),

              /* --------------------------- AUTHOR DROPDOWN --------------------------- */
              DropdownButtonFormField<String>(
                value: selectedAuthor,
                decoration: _input("Author"),
                items: authors
                    .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                    .toList(),
                onChanged: (v) => setState(() => selectedAuthor = v),
              ),
              const SizedBox(height: 16),

              /* --------------------------- STATUS DROPDOWN --------------------------- */
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: _input("Status"),
                items: statusList
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => selectedStatus = v),
              ),
              const SizedBox(height: 16),

              /* ----------------------------- FEATURED CHECK ----------------------------- */
              Row(
                children: [
                  Checkbox(
                    value: isFeatured,
                    onChanged: (v) => setState(() => isFeatured = v!),
                  ),
                  Text("Featured Article", style: text.bodyMedium),
                ],
              ),
              const SizedBox(height: 16),

              /* ------------------------------ DATE PICKER ------------------------------ */
              _datePicker("Published At", publishedAt, (d) {
                setState(() => publishedAt = d);
              }),
              const SizedBox(height: 16),

              _field("Language Code (en, km)", languageController, text),
              const SizedBox(height: 20),

              /* ------------------------------- CATEGORIES ------------------------------- */
              Text("Categories",
                  style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),

              Wrap(
                spacing: 8,
                children: categories.map((cat) {
                  final isSelected = selectedCategories.contains(cat);
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        isSelected
                            ? selectedCategories.remove(cat)
                            : selectedCategories.add(cat);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              /* --------------------------------- TAGS --------------------------------- */
              Text("Tags",
                  style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),

              Wrap(
                spacing: 8,
                children: tags.map((tag) {
                  final isSelected = selectedTags.contains(tag);
                  return ChoiceChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        isSelected
                            ? selectedTags.remove(tag)
                            : selectedTags.add(tag);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              /* ------------------------------ SAVE BUTTON ------------------------------ */
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
                      // TODO: Send to API
                    }
                  },
                  child: Text(
                    "Save Article",
                    style: text.titleMedium
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* ----------------------------- FORM FIELD MAKER ----------------------------- */
  Widget _field(
      String label,
      TextEditingController controller,
      TextTheme text, {
        bool required = false,
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: _input(label),
      validator: required ? (v) => v!.isEmpty ? "Required" : null : null,
    );
  }

  /* ------------------------------- DATE PICKER ------------------------------- */
  Widget _datePicker(String label, DateTime? value, Function(DateTime?) onPick) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: value ?? DateTime.now(),
        );
        onPick(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value == null
                ? label
                : "${value.year}-${value.month}-${value.day}"),
            const Icon(Icons.calendar_month),
          ],
        ),
      ),
    );
  }

  /* ------------------------------ INPUT DECORATION ------------------------------ */
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