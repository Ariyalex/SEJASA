import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProjectCategoryDropdown extends HookWidget {
  final String? initialValue;
  final Function(String?) onChanged;

  const ProjectCategoryDropdown({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Tukang Bangunan',
      'Desain Interior',
      'Kelistrikan',
      'Pipa & Air',
      'Pengecatan',
      'Pembersihan',
      'Perbaikan Elektronik',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori Project',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        DropdownSearch<String>(
          items: (filter, loadProps) => categories,
          selectedItem: initialValue,
          decoratorProps: const DropDownDecoratorProps(
            decoration: InputDecoration(
              hintText: 'Pilih Kategori',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
