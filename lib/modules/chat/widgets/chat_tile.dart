import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/domain/entities/list_chat_item_entity.dart';
import 'package:sejasa/domain/value_objects/participant_status_type.dart';

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
      title: Row(
        children: [
          Expanded(
            child: Text(
              chat.title,
              style: TextStyle(
                fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (chat.participantStatus != null) ...[
            const SizedBox(width: 8),
            _buildStatusChip(chat.participantStatus!, colorScheme),
          ],
        ],
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

  Widget _buildStatusChip(ParticipantStatusType status, ColorScheme colorScheme) {
    Color bgColor;
    Color textColor;
    switch (status) {
      case ParticipantStatusType.pending:
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade800;
        break;
      case ParticipantStatusType.accepted:
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade800;
        break;
      case ParticipantStatusType.rejected:
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade800;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Text(
        status.display,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
