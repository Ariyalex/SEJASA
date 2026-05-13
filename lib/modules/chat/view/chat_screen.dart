import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sejasa/modules/chat/bloc/chat_bloc.dart';
import 'package:sejasa/modules/chat/bloc/chat_event.dart';
import 'package:sejasa/modules/chat/bloc/chat_state.dart';
import 'package:sejasa/modules/chat/widgets/chat_bubble_file.dart';
import 'package:sejasa/modules/chat/widgets/chat_bubble_text.dart';
import 'package:sejasa/modules/chat/widgets/chat_input_bar.dart';
import 'package:sejasa/modules/chat/widgets/date_chip.dart';
import 'package:sejasa/modules/chat/widgets/project_info_card.dart';

class ChatScreen extends HookWidget {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? projectId;
  const ChatScreen({
    super.key,
    required this.id,
    required this.name,
    this.avatarUrl,
    this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: avatarUrl != null
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state.status == ChatStatus.loading && state.messages.isEmpty) {
            return _buildSkeleton();
          }

          if (state.status == ChatStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Terjadi kesalahan'),
            );
          }

          final hasProject = state.project != null;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.messages.length + (hasProject ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (hasProject && index == 0) {
                      return ProjectInfoCard(project: state.project!);
                    }

                    final messageIndex = hasProject ? index - 1 : index;
                    final chat = state.messages[messageIndex];
                    bool showDateChip = false;

                    if (messageIndex == 0) {
                      showDateChip = true;
                    } else {
                      final prevChat = state.messages[messageIndex - 1];
                      if (!_isSameDay(chat.timestamp, prevChat.timestamp)) {
                        showDateChip = true;
                      }
                    }

                    // Mockup logic for file bubble:
                    // Let's say if message starts with [FILE], it's a file bubble
                    final isMockFile = chat.message.startsWith('[FILE]');

                    return Column(
                      children: [
                        if (showDateChip) DateChip(date: chat.timestamp),
                        if (isMockFile)
                          ChatBubbleFile(
                            chat: chat,
                            fileName: 'Dokumen_Project_Final.pdf',
                            fileSize: '2.4 MB',
                            fileType: 'PDF',
                          )
                        else
                          ChatBubbleText(chat: chat),
                      ],
                    );
                  },
                ),
              ),
              ChatInputBar(
                onSend: (message) {
                  context.read<ChatBloc>().add(SendMessage(message));
                  // Auto scroll to bottom after send
                  Future.delayed(const Duration(milliseconds: 100), () {
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                },
                onAttach: () {
                  // Attachment mockup: Send a dummy file message
                  context.read<ChatBloc>().add(
                    const SendMessage('[FILE] Dokumen_Project_Final.pdf'),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        itemCount: 6,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          final isMe = index % 2 == 0;

          return Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Ini adalah dummy message untuk skeleton loading',
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
