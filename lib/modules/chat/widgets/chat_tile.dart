import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/domain/entities/list_chat_item_entity.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.chat, required this.onTap});

  final ListChatItemEntity chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasUnread = chat.unreadMsg > 0;

    String formattedDate = '';
    try {
      final now = DateTime.now();
      if (chat.timestamp.year == now.year &&
          chat.timestamp.month == now.month &&
          chat.timestamp.day == now.day) {
        formattedDate = DateFormat('HH:mm').format(chat.timestamp);
      } else {
        formattedDate = DateFormat('d MMM').format(chat.timestamp);
      }
    } catch (_) {
      formattedDate = '';
    }

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: colorScheme.primaryContainer,
        backgroundImage: chat.user.image != null
            ? NetworkImage(chat.user.image!)
            : null,
        child: chat.user.image == null
            ? Icon(LucideIcons.user, color: colorScheme.onPrimaryContainer)
            : null,
      ),
      title: Text(
        chat.title,
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
      subtitle: Text(
        chat.body,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            formattedDate,
            style: theme.textTheme.bodySmall?.copyWith(
              color: hasUnread
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 4),
          if (hasUnread)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Text(
                '${chat.unreadMsg}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorScheme.onPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            const SizedBox(height: 18),
        ],
      ),
    );
  }
}
