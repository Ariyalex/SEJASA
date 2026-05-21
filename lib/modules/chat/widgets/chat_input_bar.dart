import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/widgets/my_text_field.dart';

class ChatInputBar extends HookWidget {
  final Function(String) onSend;
  final VoidCallback onAttach;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.onAttach,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: MyTextField(
                title: '',
                hint: 'Ketik pesan...',
                controller: controller,
                borderRadius: 24,
                fillColor: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.5,
                ),
                suffixIcon: IconButton(
                  onPressed: onAttach,
                  icon: Icon(LucideIcons.paperclip, color: colorScheme.primary),
                ),
                onChanged: (_) {
                  // Trigger rebuild to update suffix icon state if MyTextField relies on it
                },
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  onSend(controller.text);
                  controller.clear();
                }
              },
              icon: Icon(LucideIcons.send, color: colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
