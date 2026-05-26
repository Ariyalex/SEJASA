import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';
import 'package:sejasa/domain/entities/project_category_entity.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';

class ProjectFilterBottomSheet extends HookWidget {
  final String? initialSort;
  final ProjectStatus? initialStatus;
  final String? initialCategory;
  final void Function(String? sort, ProjectStatus? status, String? category)
  onApply;

  const ProjectFilterBottomSheet({
    super.key,
    this.initialSort,
    this.initialStatus,
    this.initialCategory,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedSort = useState<String?>(initialSort);
    // Default status to hiring if null
    final selectedStatus = useState<ProjectStatus?>(
      initialStatus ?? ProjectStatus.hiring,
    );
    final selectedCategory = useState<String?>(initialCategory);
    final categorySearchController = useTextEditingController(
      text: initialCategory,
    );

    final projectRepository = context.read<ProjectRepository>();
    final categoriesState = useState<List<ProjectCategoryEntity>>([]);
    final filteredCategories = useState<List<ProjectCategoryEntity>>([]);
    final isLoadingCategories = useState<bool>(true);
    final debounceTimer = useRef<Timer?>(null);

    useEffect(() {
      projectRepository.getAllCategory().then((categories) {
        categoriesState.value = categories;
        filteredCategories.value = categories;
        isLoadingCategories.value = false;
      }).catchError((e) {
        isLoadingCategories.value = false;
      });
      return null;
    }, []);

    void onSearchChanged(String val) {
      debounceTimer.value?.cancel();
      debounceTimer.value = Timer(const Duration(milliseconds: 300), () {
        if (val.isEmpty) {
          filteredCategories.value = categoriesState.value;
        } else {
          filteredCategories.value = categoriesState.value
              .where((cat) => cat.name.toLowerCase().contains(val.toLowerCase()))
              .toList();
        }
      });
    }

    final filtered = filteredCategories.value;
    final row1Categories = <ProjectCategoryEntity>[];
    final row2Categories = <ProjectCategoryEntity>[];
    for (var i = 0; i < filtered.length; i++) {
      if (i % 2 == 0) {
        row1Categories.add(filtered[i]);
      } else {
        row2Categories.add(filtered[i]);
      }
    }

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          // spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter Proyek",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            Text(
              "Urutkan",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              spacing: 8,
              children: ['Terbaru', 'Terlama'].map((sort) {
                final isSelected = selectedSort.value == sort;
                return ChoiceChip(
                  label: Text(sort),
                  selected: isSelected,
                  onSelected: (selected) {
                    selectedSort.value = selected ? sort : null;
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 6),
            Text(
              "Status",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Wrap(
              spacing: 8,
              children: ProjectStatus.values.map((status) {
                final isSelected = selectedStatus.value == status;
                return ChoiceChip(
                  label: Text(status.label),
                  selected: isSelected,
                  onSelected: (selected) {
                    selectedStatus.value = selected ? status : null;
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 6),
            Text(
              "Kategori",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            MyTextField(
              hint: "Cari kategori...",
              controller: categorySearchController,
              onChanged: onSearchChanged,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 90,
              child: isLoadingCategories.value
                  ? const Center(child: CircularProgressIndicator())
                  : filtered.isEmpty
                      ? const Center(child: Text("Kategori tidak ditemukan"))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: row1Categories.map((cat) {
                                  final isSelected =
                                      selectedCategory.value == cat.name;
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      right: 8.0,
                                      bottom: 8.0,
                                    ),
                                    child: ChoiceChip(
                                      label: Text(cat.name),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        selectedCategory.value =
                                            selected ? cat.name : null;
                                        if (selected) {
                                          categorySearchController.text =
                                              cat.name;
                                        }
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                              Row(
                                children: row2Categories.map((cat) {
                                  final isSelected =
                                      selectedCategory.value == cat.name;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: ChoiceChip(
                                      label: Text(cat.name),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        selectedCategory.value =
                                            selected ? cat.name : null;
                                        if (selected) {
                                          categorySearchController.text =
                                              cat.name;
                                        }
                                      },
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
            ),

            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: () {
                  onApply(
                    selectedSort.value,
                    selectedStatus.value,
                    selectedCategory.value,
                  );
                  Navigator.pop(context);
                },
                child: const Text("Tampilkan Hasil"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
