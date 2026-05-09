import 'package:flutter/material.dart';

class MyVisualChip extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? textColor;
  const MyVisualChip({
    super.key,
    required this.title,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surfaceContainerHighest,
        // border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      child: Text(
        title,
        style: theme.chipTheme.labelStyle?.copyWith(
          color: textColor ?? theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
