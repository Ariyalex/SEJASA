import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

    // useListenable supaya tombol send aktif/nonaktif sesuai isi text.
    useListenable(controller);
    final hasText = controller.text.trim().isNotEmpty;

    void handleSend() {
      final text = controller.text.trim();
      if (text.isEmpty) return;
      onSend(text);
      controller.clear();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Tombol attach (paperclip) — di luar TextField supaya selalu tampil
            IconButton(
              onPressed: onAttach,
              icon: Icon(LucideIcons.paperclip, color: colorScheme.primary),
              tooltip: 'Lampirkan file',
            ),

            // Text field — pakai TextField biasa, bukan MyTextField,
            // supaya behavior input (paste, suffix, dll) bisa di-control penuh.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 5,
                  textInputAction: TextInputAction.send,
                  textCapitalization: TextCapitalization.sentences,
                  // Enter di keyboard fisik (desktop/web) -> kirim.
                  // Shift+Enter tetap masuk newline.
                  onSubmitted: (_) => handleSend(),
                  decoration: InputDecoration(
                    hintText: 'Ketik pesan...',
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: colorScheme.primary),
                    ),
                    isDense: true,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 4),

            // Tombol send — fill saat ada text, disabled saat kosong.
            IconButton.filled(
              onPressed: hasText ? handleSend : null,
              icon: const Icon(LucideIcons.send),
              tooltip: 'Kirim',
            ),
          ],
        ),
      ),
    );
  }
}
