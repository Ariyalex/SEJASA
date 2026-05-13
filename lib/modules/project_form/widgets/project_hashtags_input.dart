import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';

class ProjectHashtagsInput extends HookWidget {
  final List<String> hashtags;
  final Function(List<String>) onHashtagsChanged;

  const ProjectHashtagsInput({
    super.key,
    required this.hashtags,
    required this.onHashtagsChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Controller to maintain the text field state
    final controller = useTextEditingController(
      // Initialize with existing hashtags if any (for edit mode)
      text: hashtags.isNotEmpty ? hashtags.map((t) => '#$t').join(' ') : null,
    );

    // Regex to detect hashtags in real-time
    final hashtagRegex = RegExp(r'#(\w+)');

    void _updateHashtags(String text) {
      final matches = hashtagRegex.allMatches(text);
      final tags = matches.map((m) => m.group(1)).whereType<String>().toList();
      onHashtagsChanged(tags);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextField(
          title: 'Hashtags',
          hint: 'Masukkan hashtag (misal: #flutter #dart)',
          controller: controller,
          prefixIcon: const Icon(Icons.tag),
          onChanged: _updateHashtags,
          validator: (v) => (v?.isEmpty ?? true) ? 'Minimal 1 hashtag' : null,
        ),
        if (hashtags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: hashtags.map((tag) {
              return Chip(
                label: Text('#$tag'),
                // No deleteIcon as requested: chips are real-time display of textfield
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}
