import 'package:flutter/material.dart';

class MyTabChip extends StatelessWidget {
  const MyTabChip({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.chipTheme.backgroundColor,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Text(title),
    );
  }
}
