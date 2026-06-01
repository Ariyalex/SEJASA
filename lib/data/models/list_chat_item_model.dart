import 'package:sejasa/domain/entities/list_chat_item_entity.dart';
import 'package:sejasa/domain/value_objects/participant_status_type.dart';

class ListChatUserModel extends ListChatUserEntity {
  const ListChatUserModel({
    required super.id,
    required super.name,
    super.image,
  });

  factory ListChatUserModel.fromJson(Map<String, dynamic> json) {
    return ListChatUserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }

  ListChatUserEntity toEntity() {
    return ListChatUserEntity(id: id, name: name, image: image);
  }
}

class ListChatItemModel extends ListChatItemEntity {
  const ListChatItemModel({
    required super.id,
    required super.projectId,
    required super.user,
    required super.title,
    required super.body,
    required super.unreadMsg,
    required super.timestamp,
    super.participantStatus,
    required super.projectName,
    required super.givenRating,
  });

  factory ListChatItemModel.fromJson(Map<String, dynamic> json) {
    return ListChatItemModel(
      id: json['id'] as String? ?? '',
      projectId: json['project_id'] as String? ?? '',
      user: ListChatUserModel.fromJson(
        json['user'] as Map<String, dynamic>? ?? {},
      ),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      unreadMsg: json['unread_msg'] as int? ?? 0,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
      participantStatus: json['participant_status'] != null
          ? ParticipantStatusType.fromJson(json['participant_status'] as String)
          : null,
      givenRating: json['rating_given'] as double? ?? 0,
      projectName: json['project_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
      'user': (user as ListChatUserModel).toJson(),
      'title': title,
      'body': body,
      'unread_msg': unreadMsg,
      'timestamp': timestamp.toIso8601String(),
      if (participantStatus != null)
        'participant_status': participantStatus!.jsonValue,
      'rating_given': givenRating,
      'project_name': projectName,
    };
  }

  ListChatItemEntity toEntity() {
    return ListChatItemEntity(
      id: id,
      projectId: projectId,
      user: user,
      title: title,
      body: body,
      unreadMsg: unreadMsg,
      timestamp: timestamp,
      participantStatus: participantStatus,
      projectName: projectName,
      givenRating: givenRating,
    );
  }
}
