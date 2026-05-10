import 'package:flutter/material.dart';

class MyTabChip extends StatelessWidget {
  final String title;
  final bool selected;
  final ValueChanged<bool> onSelected;
  const MyTabChip({
    super.key,
    required this.title,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChoiceChip(
      label: Text(title),
      selected: selected,
      showCheckmark: false,
      onSelected: onSelected,
      backgroundColor: theme.scaffoldBackgroundColor,
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: selected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? Colors.transparent : theme.dividerColor,
        ),
      ),
    );
  }
}
