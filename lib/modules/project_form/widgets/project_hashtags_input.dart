import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    final controller = useTextEditingController();

    void addHashtag(String value) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) return;

      // Extract hashtags if multiple are pasted or typed
      final newTags = trimmed
          .split(' ')
          .where((tag) => tag.startsWith('#'))
          .map((tag) => tag.substring(1))
          .where((tag) => tag.isNotEmpty && !hashtags.contains(tag))
          .toList();

      if (newTags.isNotEmpty) {
        onHashtagsChanged([...hashtags, ...newTags]);
        controller.clear();
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hashtags',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Masukkan hashtag (misal: #flutter #dart)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.tag),
          ),
          onChanged: (value) {
            if (value.endsWith(' ')) {
              addHashtag(value);
            }
          },
          onSubmitted: addHashtag,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: hashtags.map((tag) {
            return Chip(
              label: Text('#$tag'),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                final updated = hashtags.where((t) => t != tag).toList();
                onHashtagsChanged(updated);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
