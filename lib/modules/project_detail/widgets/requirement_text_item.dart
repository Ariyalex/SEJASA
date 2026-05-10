import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class RequirementTextItem extends StatelessWidget {
  final String text;
  const RequirementTextItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(LucideIcons.dot),
        Expanded(child: Text(text, overflow: TextOverflow.visible)),
      ],
    );
  }
}
