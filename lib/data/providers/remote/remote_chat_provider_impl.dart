import 'package:sejasa/core/services/api_service.dart';
import 'package:sejasa/data/models/list_chat_item_model.dart';
import 'package:sejasa/domain/providers/remote_chat_provider.dart';

class RemoteChatProviderImpl extends RemoteChatProvider {
  final ApiService _apiService;
  RemoteChatProviderImpl(this._apiService);

  @override
  Future<List<ListChatItemModel>> getListProjectChat(String projectId) async {
    final response = await _apiService.get('/project/$projectId/chat');
    final rawData = response.data['data'] as List?;

    return List<ListChatItemModel>.from(
      rawData?.map((e) => ListChatItemModel.fromJson(e)) ?? [],
    );
  }

  @override
  Future<List<ListChatItemModel>> getListUserChat() async {
    final response = await _apiService.get('/chat');
    final rawData = response.data['data'] as List?;

    return List<ListChatItemModel>.from(
      rawData?.map((e) => ListChatItemModel.fromJson(e)) ?? [],
    );
  }
}
