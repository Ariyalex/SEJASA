import 'package:sejasa/domain/entities/list_user_item_entity.dart';
import 'package:sejasa/domain/value_objects/account_type.dart';

class ListUserItemModel extends ListUserItemEntity {
  const ListUserItemModel({
    required super.id,
    required super.name,
    required super.email,
    required super.accountType,
  });

  factory ListUserItemModel.fromJson(Map<String, dynamic> json) {
    return ListUserItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      accountType: AccountType.fromJson(json['account_type'] ?? 'personal'),
    );
  }

  ListUserItemEntity toEntity() {
    return ListUserItemEntity(
      id: id,
      name: name,
      email: email,
      accountType: accountType,
    );
  }
}
