import 'package:equatable/equatable.dart';

class MainTabState extends Equatable {
  final int currentIndex;

  const MainTabState({this.currentIndex = 0});

  MainTabState copyWith({int? currentIndex}) {
    return MainTabState(currentIndex: currentIndex ?? this.currentIndex);
  }

  @override
  List<Object?> get props => [currentIndex];
}
