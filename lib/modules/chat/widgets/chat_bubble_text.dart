import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';

class ChatBubbleText extends StatelessWidget {
  final ChatEntity chat;
  const ChatBubbleText({super.key, required this.chat});

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
            Text(
              chat.message,
              style: TextStyle(
                color: isMe ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
              ),
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
