import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';
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

    final allCategories = useMemoized(
      () => [
        'Plumbing',
        'Electrical',
        'Cleaning',
        'Painting',
        'Carpentry',
        'Gardening',
        'Roofing',
        'Flooring',
        'Masonry',
        'AC Repair',
      ],
    );
    final filteredCategories = useState<List<String>>(allCategories);
    final debounceTimer = useRef<Timer?>(null);

    void onSearchChanged(String val) {
      debounceTimer.value?.cancel();
      debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
        if (val.isEmpty) {
          filteredCategories.value = allCategories;
        } else {
          filteredCategories.value = allCategories
              .where((cat) => cat.toLowerCase().contains(val.toLowerCase()))
              .toList();
        }
      });
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
          spacing: 16,
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

            Text(
              "Kategori",
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            MyTextField(
              title: "",
              hint: "Cari kategori...",
              controller: categorySearchController,
              onChanged: onSearchChanged,
            ),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 100,
              ), // Height for approx 2 rows
              child: ClipRect(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  clipBehavior: Clip.hardEdge,
                  children: filteredCategories.value.map((cat) {
                    final isSelected = selectedCategory.value == cat;
                    return ChoiceChip(
                      label: Text(
                        cat,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        selectedCategory.value = selected ? cat : null;
                        if (selected) {
                          categorySearchController.text = cat;
                        }
                      },
                    );
                  }).toList(),
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
