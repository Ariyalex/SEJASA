import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/utils/my_snackbar.dart';
import 'package:sejasa/domain/entities/chat_entity.dart';
import 'package:sejasa/domain/repositories/file_repository.dart';

class ChatBubbleFile extends HookWidget {
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
    final fileRepository = useMemoized(() => getIt<FileRepository>());

    final isDownloading = useState<bool>(false);
    final localPath = useState<String?>(null);

    // Dynamic filename for local storage from the URL
    final remoteUrl = chat.file;

    useEffect(() {
      if (remoteUrl == null || remoteUrl.isEmpty) return null;

      void checkLocalFile() async {
        try {
          final directory = await getApplicationDocumentsDirectory();
          final uri = Uri.parse(remoteUrl);
          final actualFileName = uri.pathSegments.isNotEmpty
              ? uri.pathSegments.last
              : 'document.pdf';
          final localFile = File('${directory.path}/$actualFileName');
          if (await localFile.exists()) {
            localPath.value = localFile.path;
          }
        } catch (e) {
          // Silent catch
        }
      }

      checkLocalFile();
      return null;
    }, [remoteUrl]);

    Future<void> handleFileAction() async {
      if (remoteUrl == null || remoteUrl.isEmpty) return;

      if (localPath.value != null) {
        // File already downloaded, open it directly using open_filex
        try {
          final result = await OpenFilex.open(localPath.value!);
          if (result.type != ResultType.done) {
            MySnackbar.error(
              message: 'Tidak dapat membuka file: ${result.message}',
            );
          }
        } catch (e) {
          MySnackbar.error(message: 'Gagal membuka file: $e');
        }
      } else {
        // Start download
        try {
          isDownloading.value = true;

          final directory = await getApplicationDocumentsDirectory();
          final uri = Uri.parse(remoteUrl);
          final actualFileName = uri.pathSegments.isNotEmpty
              ? uri.pathSegments.last
              : 'document.pdf';
          final localFile = File('${directory.path}/$actualFileName');

          // Download using repository
          final downloadedFile = await fileRepository.downloadUploadedFile(
            remoteUrl,
          );

          // Write to local documents folder
          final bytes = await downloadedFile.readAsBytes();
          await localFile.writeAsBytes(bytes);

          localPath.value = localFile.path;
          MySnackbar.success(
            message: 'Berkas berhasil diunduh ke penyimpanan lokal.',
          );

          // Automatically open it once downloaded
          try {
            await OpenFilex.open(localFile.path);
          } catch (e) {
            // Silent error on auto-open
          }
        } catch (e) {
          MySnackbar.error(message: 'Gagal mengunduh berkas: $e');
        } finally {
          isDownloading.value = false;
        }
      }
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? colorScheme.primary
              : colorScheme.surfaceContainerHighest,
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
                    color: (isMe ? Colors.white : colorScheme.primary)
                        .withAlpha(51), // equivalent to withOpacity(0.2)
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
                          color: isMe
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$fileType • $fileSize',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              (isMe
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurfaceVariant)
                                  .withAlpha(
                                    179,
                                  ), // equivalent to withOpacity(0.7)
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: isDownloading.value ? null : handleFileAction,
                  icon: isDownloading.value
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              isMe
                                  ? colorScheme.onPrimary
                                  : colorScheme.primary,
                            ),
                          ),
                        )
                      : Icon(
                          localPath.value != null
                              ? LucideIcons.eye
                              : LucideIcons.download,
                          size: 20,
                          color: isMe
                              ? colorScheme.onPrimary
                              : colorScheme.primary,
                        ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('HH:mm').format(chat.timestamp),
              style: TextStyle(
                fontSize: 10,
                color:
                    (isMe
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant)
                        .withAlpha(179), // equivalent to withOpacity(0.7)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
