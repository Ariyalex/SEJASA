import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/config/app_config.dart';
import 'package:sejasa/domain/entities/list_chat_item_entity.dart';
import 'package:sejasa/domain/value_objects/participant_status_type.dart';
import 'package:sejasa/domain/value_objects/project_status.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.chat,
    required this.onTap,
    this.isPelamarList = false,
    this.projectStatus,
    this.onRatePressed,
  });

  final ListChatItemEntity chat;
  final VoidCallback onTap;
  final bool isPelamarList;
  final ProjectStatus? projectStatus;
  final VoidCallback? onRatePressed;

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
            ? NetworkImage(AppConfig.baseUrl + chat.user.image!)
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
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                size: 14,
                color: colorScheme.primary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  chat.projectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            chat.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
          if (isPelamarList &&
              chat.participantStatus == ParticipantStatusType.accepted) ...[
            if (chat.givenRating != 0) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    "Rating Anda: ${chat.givenRating.toStringAsFixed(1)} / 5",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.amber[800],
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ] else if (projectStatus == ProjectStatus.going) ...[
              const SizedBox(height: 6),
              SizedBox(
                height: 28,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.amber[800],
                    side: BorderSide(color: Colors.amber[800]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 0,
                    ),
                  ),
                  icon: const Icon(Icons.star_rounded, size: 14),
                  label: const Text(
                    "Beri Rating",
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  onPressed: onRatePressed,
                ),
              ),
            ],
          ],
        ],
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
            ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(
    ParticipantStatusType status,
    ColorScheme colorScheme,
  ) {
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
