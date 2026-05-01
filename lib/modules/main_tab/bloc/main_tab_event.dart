import 'package:equatable/equatable.dart';

abstract class MainTabEvent extends Equatable {
  const MainTabEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTab extends MainTabEvent {
  final int index;
  const ChangeTab(this.index);

  @override
  List<Object?> get props => [index];
}
