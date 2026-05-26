import 'package:sejasa/data/models/list_chat_item_model.dart';

abstract class RemoteChatProvider {
  Future<List<ListChatItemModel>> getListUserChat();
  Future<List<ListChatItemModel>> getListProjectChat(String projectId);
}
