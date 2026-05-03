import 'package:flutter/material.dart';

class MyChip extends StatelessWidget {
  const MyChip({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.chipTheme.backgroundColor,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
      child: Text("status"),
    );
  }
}
