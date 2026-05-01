import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sejasa/modules/main_tab/bloc/main_tab_event.dart';
import 'package:sejasa/modules/main_tab/bloc/main_tab_state.dart';

class MainTabBloc extends Bloc<MainTabEvent, MainTabState> {
  final PersistentTabController mainTabController = PersistentTabController(
    initialIndex: 0,
  );

  MainTabBloc() : super(const MainTabState()) {
    on<ChangeTab>(_onChangeTab);
  }

  void _onChangeTab(ChangeTab event, Emitter<MainTabState> emit) {
    if (mainTabController.index != event.index) {
      mainTabController.jumpToTab(event.index);
    }
    emit(state.copyWith(currentIndex: event.index));
  }
}
