import 'package:equatable/equatable.dart';
import 'package:sejasa/domain/value_objects/account_type.dart';

class ListUserItemEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final AccountType accountType;

  const ListUserItemEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.accountType,
  });

  ListUserItemEntity copyWith({
    final String? id,
    final String? name,
    final String? email,
    final AccountType? accountType,
  }) {
    return ListUserItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      accountType: accountType ?? this.accountType,
    );
  }

  @override
  List<Object?> get props => [id, name, email, accountType];
}
