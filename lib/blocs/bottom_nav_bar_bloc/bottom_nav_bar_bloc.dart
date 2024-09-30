import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_bar_event.dart';
part 'bottom_nav_bar_state.dart';

class BottomNavBarBloc extends Bloc<BottomNavBarEvent, BottomNavBarState> {
  BottomNavBarBloc() : super(const BottomNavBarInitial(selectedIndex: 0)) {
    on<BottomNavBarIndexChanged>(_onIndexChanged);
  }

  void _onIndexChanged(BottomNavBarIndexChanged event, Emitter<BottomNavBarState> emit) {
    emit(BottomNavBarInitial(selectedIndex: event.index));
  }
}
