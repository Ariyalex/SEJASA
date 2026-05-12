import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';

class ChatBubbleFile extends StatelessWidget {
  final ChatEntity chat;
  final String fileName;
  final String fileSize;
  final String fileType;

  const ChatBubbleFile({
    super.key,
    required this.chat,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMe = chat.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe ? colorScheme.primary : colorScheme.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMe ? 12 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (isMe ? Colors.white : colorScheme.primary).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    LucideIcons.file,
                    color: isMe ? colorScheme.onPrimary : colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isMe ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$fileType • $fileSize',
                        style: TextStyle(
                          fontSize: 12,
                          color: (isMe ? colorScheme.onPrimary : colorScheme.onSurfaceVariant)
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Download action mock
                  },
                  icon: Icon(
                    LucideIcons.download,
                    size: 20,
                    color: isMe ? colorScheme.onPrimary : colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(chat.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: (isMe ? colorScheme.onPrimary : colorScheme.onSurfaceVariant)
                    .withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
