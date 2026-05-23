import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/utils/my_snackbar.dart';
import 'package:sejasa/domain/entities/project_entity.dart';
import 'package:sejasa/domain/repositories/project_repository.dart';
import 'package:sejasa/domain/value_objects/participant_status_type.dart';
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
  final ParticipantStatusType? participantStatus;
  final bool isOwner;
  final String? participantId;

  const ChatScreen({
    super.key,
    required this.id,
    required this.name,
    this.avatarUrl,
    this.projectId,
    this.participantStatus,
    this.isOwner = false,
    this.participantId,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final chatBloc = context.read<ChatBloc>();
    final hasProject = projectId != null;
    final projectRepository = useMemoized(() => getIt<ProjectRepository>());
    final currentStatus = useState<ParticipantStatusType?>(participantStatus);
    final isProcessingAction = useState<bool>(false);

    useEffect(() {
      if (hasProject) {
        chatBloc.add(LoadChatProject(projectId!));
      }
      return null;
    }, [projectId]);

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

          return Column(
            children: [
              if (isOwner &&
                  currentStatus.value == ParticipantStatusType.pending &&
                  projectId != null &&
                  participantId != null)
                _buildApplicantActionPanel(
                  context,
                  projectRepository: projectRepository,
                  currentStatus: currentStatus,
                  isProcessingAction: isProcessingAction,
                ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: state.messages.length + (hasProject ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (hasProject && index == 0) {
                      if (state.isFetchingProject || state.project == null) {
                        return Skeletonizer(
                          child: ProjectInfoCard(
                            project: ProjectEntity.dummyProject(),
                            isSkeleton: true,
                          ),
                        );
                      } else {
                        return ProjectInfoCard(project: state.project!);
                      }
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

                    // Logic for file bubble:
                    // Supports both actual files and the mockup '[FILE]' prefix
                    final isFile =
                        chat.file != null || chat.message.startsWith('[FILE]');
                    String fileName = 'Dokumen_Project_Final.pdf';
                    String fileType = 'PDF';
                    String fileSize = '2.4 MB';

                    if (chat.file != null) {
                      fileName = chat.file!.split('/').last;
                      final parts = fileName.split('.');
                      fileType = parts.length > 1
                          ? parts.last.toUpperCase()
                          : 'FILE';
                      fileSize = 'Unknown Size';
                    }

                    return Column(
                      children: [
                        if (showDateChip) DateChip(date: chat.timestamp),
                        if (isFile)
                          ChatBubbleFile(
                            chat: chat,
                            fileName: fileName,
                            fileSize: fileSize,
                            fileType: fileType,
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

  Widget _buildApplicantActionPanel(
    BuildContext context, {
    required ProjectRepository projectRepository,
    required ValueNotifier<ParticipantStatusType?> currentStatus,
    required ValueNotifier<bool> isProcessingAction,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Pelamar Proyek Pending',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Pengguna ini melamar untuk bergabung dengan proyek Anda. Harap konfirmasi untuk menerima atau menolak pelamar ini.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: isProcessingAction.value
                      ? null
                      : () async {
                          try {
                            isProcessingAction.value = true;
                            await projectRepository.rejectProjectParticipant(
                              projectId!,
                              participantId!,
                            );
                            currentStatus.value =
                                ParticipantStatusType.rejected;
                            MySnackbar.success(
                              message: "Berhasil menolak pelamar",
                            );
                          } catch (e) {
                            MySnackbar.error(message: e.toString());
                          } finally {
                            isProcessingAction.value = false;
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isProcessingAction.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor: AlwaysStoppedAnimation(Colors.red),
                          ),
                        )
                      : const Text('Tolak'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: isProcessingAction.value
                      ? null
                      : () async {
                          try {
                            isProcessingAction.value = true;
                            await projectRepository.acceptProjectParticipant(
                              projectId!,
                              participantId!,
                            );
                            currentStatus.value =
                                ParticipantStatusType.accepted;
                            MySnackbar.success(
                              message: "Berhasil menerima pelamar",
                            );
                          } catch (e) {
                            MySnackbar.error(message: e.toString());
                          } finally {
                            isProcessingAction.value = false;
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isProcessingAction.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text('Terima'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
