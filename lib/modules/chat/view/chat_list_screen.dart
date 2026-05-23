import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/routes/route_named.dart';
import 'package:sejasa/core/widgets/my_tab_chip.dart';
import 'package:sejasa/domain/value_objects/participant_status_type.dart';
import 'package:sejasa/modules/chat/bloc/chat_list_bloc.dart';
import 'package:sejasa/modules/chat/bloc/chat_list_event.dart';
import 'package:sejasa/modules/chat/bloc/chat_list_state.dart';
import 'package:sejasa/modules/chat/widgets/chat_list_empty.dart';
import 'package:sejasa/modules/chat/widgets/chat_tile.dart';

/// Screen daftar chat (chat dashboard) — sesuai mockup UAS.
class ChatListScreen extends HookWidget {
  final String? projectId;

  const ChatListScreen({super.key, this.projectId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final selectedStatus = useState<ParticipantStatusType?>(null);

    // Sinkronkan controller -> state agar list ter-filter realtime
    useEffect(() {
      void listener() => searchQuery.value = searchController.text;
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    // Pemicu event BLoC sesuai ketersediaan projectId
    useEffect(() {
      final bloc = context.read<ChatListBloc>();
      if (projectId != null) {
        bloc.add(LoadProjectChats(projectId!));
      } else {
        bloc.add(const LoadUserChats());
      }
      return null;
    }, [projectId]);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          projectId != null ? 'Pelamar Proyek' : 'Chat Dashboard',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
      ),
      body: BlocBuilder<ChatListBloc, ChatListState>(
        builder: (context, state) {
          if (state.status == ChatListStatus.initial ||
              state.status == ChatListStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ChatListStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      LucideIcons.alertTriangle,
                      color: colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage ?? 'Gagal memuat daftar chat',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        final bloc = context.read<ChatListBloc>();
                        if (projectId != null) {
                          bloc.add(LoadProjectChats(projectId!));
                        } else {
                          bloc.add(const LoadUserChats());
                        }
                      },
                      icon: const Icon(LucideIcons.refreshCw, size: 16),
                      label: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final allChats = state.chats;
          final filteredChats = allChats.where((c) {
            final q = searchQuery.value.trim().toLowerCase();
            if (q.isNotEmpty) {
              final matchesQuery = c.title.toLowerCase().contains(q) ||
                  c.body.toLowerCase().contains(q);
              if (!matchesQuery) return false;
            }
            if (projectId != null && selectedStatus.value != null) {
              return c.participantStatus == selectedStatus.value;
            }
            return true;
          }).toList();

          return Column(
            children: [
              // Search bar — sesuai mockup ("Chat melamar project")
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Chat melamar project',
                    prefixIcon: const Icon(LucideIcons.search, size: 20),
                    suffixIcon: searchQuery.value.isNotEmpty
                        ? IconButton(
                            icon: const Icon(LucideIcons.x, size: 18),
                            onPressed: searchController.clear,
                          )
                        : null,
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Filter chips (hanya jika projectId != null)
              if (projectId != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        MyTabChip(
                          title: 'Semua',
                          selected: selectedStatus.value == null,
                          onSelected: (_) => selectedStatus.value = null,
                        ),
                        const SizedBox(width: 8),
                        ...ParticipantStatusType.values.map((status) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: MyTabChip(
                              title: status.display,
                              selected: selectedStatus.value == status,
                              onSelected: (_) => selectedStatus.value = status,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),

              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<ChatListBloc>();
                    if (projectId != null) {
                      await Future.wait([
                        Future.microtask(
                          () => bloc.add(LoadProjectChats(projectId!)),
                        ),
                        bloc.stream.firstWhere(
                          (state) => state.status != ChatListStatus.loading,
                        ),
                      ]);
                    } else {
                      await Future.wait([
                        Future.microtask(() => bloc.add(const LoadUserChats())),
                        bloc.stream.firstWhere(
                          (state) => state.status != ChatListStatus.loading,
                        ),
                      ]);
                    }
                  },
                  child: filteredChats.isEmpty
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            return ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: ChatListEmpty(
                                    searchQuery: searchQuery.value,
                                  ),
                                ),
                              ],
                            );
                          },
                        )
                      : ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 16),
                          itemCount: filteredChats.length,
                          separatorBuilder: (_, _) => Divider(
                            height: 1,
                            indent: 80,
                            endIndent: 16,
                            color: colorScheme.outlineVariant,
                          ),
                          itemBuilder: (context, index) {
                            final chat = filteredChats[index];
                            return ChatTile(
                              chat: chat,
                              onTap: () {
                                context.pushNamed(
                                  RouteNamed.chat,
                                  pathParameters: {'id': chat.id},
                                  extra: {
                                    'name': chat.title,
                                    'avatar_url': chat.user.image,
                                    'project_id': chat.projectId,
                                    'participant_status': chat.participantStatus,
                                    'is_owner': projectId != null,
                                    'user_id': chat.user.id,
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
