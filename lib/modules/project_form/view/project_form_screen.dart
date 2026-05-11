import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:latlong2/latlong.dart';
import 'package:sejasa/data/entities/project.dart';
import 'package:sejasa/data/value_objects/project_status.dart';
import 'package:sejasa/modules/project_form/bloc/project_form_bloc.dart';
import 'package:sejasa/modules/project_form/bloc/project_form_event.dart';
import 'package:sejasa/modules/project_form/bloc/project_form_state.dart';
import 'package:sejasa/modules/project_form/widgets/project_category_dropdown.dart';
import 'package:sejasa/modules/project_form/widgets/project_description_editor.dart';
import 'package:sejasa/modules/project_form/widgets/project_hashtags_input.dart';
import 'package:sejasa/modules/project_form/widgets/project_location_picker.dart';
import 'package:sejasa/modules/project_form/widgets/project_requirements_list.dart';

class ProjectFormScreen extends HookWidget {
  final Project? initialProject;

  const ProjectFormScreen({super.key, this.initialProject});

  bool get isEditMode => initialProject != null;

  @override
  Widget build(BuildContext context) {
    // Hooks for state management
    final titleController = useTextEditingController(
      text: initialProject?.title,
    );
    final addressController = useTextEditingController(
      text: initialProject?.address,
    );
    final detailAddressController = useTextEditingController(
      text: initialProject?.detailAddress,
    );

    final selectedCategory = useState<String?>(initialProject?.category);
    final selectedLocation = useState<LatLng?>(
      initialProject?.latitude != null && initialProject?.longitude != null
          ? LatLng(initialProject!.latitude!, initialProject!.longitude!)
          : null,
    );

    final requirements = useState<List<String>>(
      initialProject?.requirements ?? [],
    );
    final hashtags = useState<List<String>>(initialProject?.hastags ?? []);

    // Quill Controller hook
    final quillController = useMemoized(() {
      if (initialProject?.description != null) {
        try {
          // Assume description is stored as JSON string (Delta)
          final doc = Document.fromJson(
            jsonDecode(initialProject!.description!),
          );
          return QuillController(
            document: doc,
            selection: const TextSelection.collapsed(offset: 0),
          );
        } catch (_) {
          // Fallback to plain text if JSON decode fails
          return QuillController.basic()
            ..document.insert(0, initialProject!.description!);
        }
      }
      return QuillController.basic();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Project' : 'Tambah Project'),
      ),
      body: BlocListener<ProjectFormBloc, ProjectFormState>(
        listener: (context, state) {
          if (state.status == ProjectFormStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  isEditMode
                      ? 'Project berhasil diubah'
                      : 'Project berhasil diposting',
                ),
              ),
            );
            Navigator.pop(context, true);
          } else if (state.status == ProjectFormStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Terjadi kesalahan')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul Project
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Nama Project',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              ProjectCategoryDropdown(
                initialValue: selectedCategory.value,
                onChanged: (val) => selectedCategory.value = val,
              ),
              const SizedBox(height: 16),

              // Location Picker (Map)
              ProjectLocationPicker(
                initialLocation: selectedLocation.value,
                onLocationChanged: (LatLng location, address) {
                  selectedLocation.value = location;
                  if (addressController.text.isEmpty) {
                    addressController.text = address;
                  }
                },
              ),
              const SizedBox(height: 16),

              // Alamat Field
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Alamat Project',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.map),
                ),
              ),
              const SizedBox(height: 16),

              // Detail Alamat (Form Besar)
              TextField(
                controller: detailAddressController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Detail Alamat',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Description Editor (Rich Text)
              ProjectDescriptionEditor(controller: quillController),
              const SizedBox(height: 16),

              // Requirements List
              ProjectRequirementsList(
                requirements: requirements.value,
                onAdd: (req) =>
                    requirements.value = [...requirements.value, req],
                onRemove: (index) {
                  final newList = List<String>.from(requirements.value);
                  newList.removeAt(index);
                  requirements.value = newList;
                },
              ),
              const SizedBox(height: 16),

              // Hashtags Input
              ProjectHashtagsInput(
                hashtags: hashtags.value,
                onHashtagsChanged: (tags) => hashtags.value = tags,
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  // Basic validation
                  if (titleController.text.isEmpty ||
                      selectedCategory.value == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Judul dan Kategori wajib diisi'),
                      ),
                    );
                    return;
                  }

                  final descriptionJson = jsonEncode(
                    quillController.document.toDelta().toJson(),
                  );

                  final project = Project(
                    id:
                        initialProject?.id ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    title: titleController.text,
                    address: addressController.text,
                    detailAddress: detailAddressController.text,
                    latitude: selectedLocation.value?.latitude,
                    longitude: selectedLocation.value?.longitude,
                    status: initialProject?.status ?? ProjectStatus.hiring,
                    distance: initialProject?.distance ?? '0 km',
                    participant: initialProject?.participant ?? '0',
                    category: selectedCategory.value!,
                    description: descriptionJson,
                    requirements: requirements.value,
                    hastags: hashtags.value,
                    ownerName: initialProject?.ownerName ?? 'User', // Mock
                    ownerRating: initialProject?.ownerRating ?? 5.0,
                    isBookmark: initialProject?.isBookmark ?? false,
                  );

                  if (isEditMode) {
                    context.read<ProjectFormBloc>().add(EditProject(project));
                  } else {
                    context.read<ProjectFormBloc>().add(AddNewProject(project));
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: BlocBuilder<ProjectFormBloc, ProjectFormState>(
                  builder: (context, state) {
                    if (state.status == ProjectFormStatus.loading) {
                      return const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      );
                    }
                    return Text(
                      isEditMode ? 'Simpan Perubahan' : 'Posting Project',
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
