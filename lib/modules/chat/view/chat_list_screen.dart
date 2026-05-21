import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:sejasa/core/routes/route_named.dart';

/// Model dummy untuk item chat di list dashboard.
/// Ganti dengan entity asli (mis. `ChatListEntity` di domain/entities)
/// saat bloc untuk list chat sudah dibuat.
class ChatListItem {
  const ChatListItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.date,
    required this.unreadCount,
    this.avatarUrl,
    this.projectId,
  });

  final String id;
  final String name;
  final String lastMessage;
  final String date;
  final int unreadCount;
  final String? avatarUrl;
  final String? projectId;
}

/// Screen daftar chat (chat dashboard) — sesuai mockup UAS.
///
/// Tampilan only. Data masih dummy untuk preview UI.
/// Nanti diganti dengan `BlocBuilder<ChatListBloc, ChatListState>`
/// saat bloc-nya tersedia.
class ChatListScreen extends HookWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final searchController = useTextEditingController();
    final searchQuery = useState('');

    // Sinkronkan controller -> state agar list ter-filter realtime
    useEffect(() {
      void listener() => searchQuery.value = searchController.text;
      searchController.addListener(listener);
      return () => searchController.removeListener(listener);
    }, [searchController]);

    // Data dummy untuk preview tampilan
    final allChats = useMemoized(
      () => List<ChatListItem>.generate(
        7,
        (i) => ChatListItem(
          id: 'chat-$i',
          name: 'Nama Akun ${i + 1}',
          lastMessage: 'Chat terakhir...',
          date: '17 Mei',
          unreadCount: i % 3 == 0 ? (i + 1) : 0,
          projectId: 'project-${i + 1}',
        ),
      ),
      [],
    );

    // Filter pencarian (case-insensitive)
    final filteredChats = useMemoized(() {
      final q = searchQuery.value.trim().toLowerCase();
      if (q.isEmpty) return allChats;
      return allChats
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) ||
                c.lastMessage.toLowerCase().contains(q),
          )
          .toList();
    }, [searchQuery.value, allChats]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
      ),
      body: Column(
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

          Expanded(
            child: filteredChats.isEmpty
                ? _EmptyState(searchQuery: searchQuery.value)
                : ListView.separated(
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
                      return _ChatTile(
                        chat: chat,
                        onTap: () {
                          // Navigasi ke detail chat (ChatScreen existing).
                          // Route /chat/:id sudah didefinisikan di AppRouter
                          // dan menerima `extra` berupa Map.
                          context.pushNamed(
                            RouteNamed.chat,
                            pathParameters: {'id': chat.id},
                            extra: {
                              'name': chat.name,
                              'avatar_url': chat.avatarUrl,
                              'project_id': chat.projectId,
                            },
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat, required this.onTap});

  final ChatListItem chat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasUnread = chat.unreadCount > 0;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        radius: 26,
        backgroundColor: colorScheme.primaryContainer,
        backgroundImage: chat.avatarUrl != null
            ? NetworkImage(chat.avatarUrl!)
            : null,
        child: chat.avatarUrl == null
            ? Icon(LucideIcons.user, color: colorScheme.onPrimaryContainer)
            : null,
      ),
      title: Text(
        chat.name,
        style: TextStyle(
          fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
      subtitle: Text(
        chat.lastMessage,
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
            chat.date,
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
                '${chat.unreadCount}',
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

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSearching = searchQuery.isNotEmpty;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSearching ? LucideIcons.searchX : LucideIcons.messageSquareDashed,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            isSearching
                ? 'Tidak ada chat yang cocok'
                : 'Belum ada chat untuk ditampilkan',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
