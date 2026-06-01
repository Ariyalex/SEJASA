import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/domain/entities/project_category_entity.dart';

class ProjectCategoryDropdown extends HookWidget {
  final ProjectCategoryEntity? initialValue;
  final Function(ProjectCategoryEntity?) onChanged;
  final FormFieldValidator<ProjectCategoryEntity>? validator;
  final List<ProjectCategoryEntity> categories;

  const ProjectCategoryDropdown({
    super.key,
    this.initialValue,
    required this.onChanged,
    this.validator,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kategori Project',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4), // Matching MyTextField gap
        DropdownSearch<ProjectCategoryEntity>(
          items: (filter, loadProps) => categories,
          itemAsString: (item) => item.name,
          compareFn: (item1, item2) => item1 != item2,
          selectedItem: initialValue,
          validator: validator,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: 'Pilih Kategori',
              filled: true,
              fillColor: const Color(0xFFEEEEEE),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
          ),
          popupProps: const PopupProps.menu(
            showSearchBox: true,
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: 'Cari kategori...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          onSelected: onChanged,
        ),
      ],
    );
  }
}
