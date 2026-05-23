import 'dart:convert';
import 'package:sejasa/core/di/dependency_injection.dart';
import 'package:sejasa/core/services/socket_service.dart';
import 'package:sejasa/data/models/chat_model.dart';
import 'package:sejasa/domain/providers/chat_socket_provider.dart';
import 'package:sejasa/modules/auth/bloc/auth_bloc.dart';

import 'package:sejasa/core/utils/log_utils.dart';

class ChatSocketProviderImpl implements ChatSocketProvider {
  final SocketService _socketService;

  ChatSocketProviderImpl(this._socketService);

  @override
  Stream<ChatModel> get messageStream {
    return _socketService.stream.asyncExpand((data) async* {
      try {
        final dataStr = data as String;
        // Ignore literal 'ping' or 'pong' strings
        if (dataStr.trim().toLowerCase() == 'ping' || dataStr.trim().toLowerCase() == 'pong') {
          LogUtils.i('Ignoring raw ping/pong message: $dataStr');
          return;
        }

        final decoded = jsonDecode(dataStr);
        if (decoded is! Map<String, dynamic>) {
          LogUtils.w('Decoded websocket data is not a Map: $decoded');
          return;
        }

        final event = decoded['event'] as String?;
        final currentUserId = getIt<AuthBloc>().state.user?.id;

        if (event == 'History') {
          final list = decoded['data'] as List<dynamic>;
          for (final item in list) {
            yield ChatModel.fromJson(
              item as Map<String, dynamic>,
              currentUserId: currentUserId,
            );
          }
        } else if (event == 'NewMessage') {
          final item = decoded['data'] as Map<String, dynamic>;
          yield ChatModel.fromJson(item, currentUserId: currentUserId);
        } else if (event == null) {
          // Only yield if event is null (meaning it's a raw message payload from the server without an event wrapper)
          yield ChatModel.fromJson(decoded, currentUserId: currentUserId);
        } else {
          // Ignore other events like 'ping', 'Ping', etc.
          LogUtils.i('Ignoring WebSocket event: $event');
        }
      } catch (e, stackTrace) {
        LogUtils.e('Error decoding WebSocket message: $e', e, stackTrace);
      }
    });
  }

  @override
  void sendMessage(ChatModel chat) {
    final Map<String, dynamic> payload = {
      'content': chat.message,
      'file': chat.file ?? '',
    };
    _socketService.send(jsonEncode(payload));
  }

  @override
  void connect(String url) {
    _socketService.connect(url);
  }

  @override
  void disconnect() {
    _socketService.disconnect();
  }
}
