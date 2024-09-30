// ignore_for_file: unused_local_variable, avoid_print
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retsept_app/blocs/user_retsept_bloc/user_retcept_event.dart';
import 'package:retsept_app/blocs/user_retsept_bloc/user_retcept_state.dart';
import 'package:retsept_app/data/repositories/retsept_repository.dart';

class UserRetseptBloc extends Bloc<UserRetseptEvent, UserRetseptState> {
  final RetseptRepository _retseptRepository;
  UserRetseptBloc({
    required RetseptRepository retseptRepository,
  })  : _retseptRepository = retseptRepository,
        super(InitialUserRetseptState()) {
    on<GetUserRetseptEvent>(_getUserRetsept);
  }

  void _getUserRetsept(GetUserRetseptEvent event, Emitter emit) async {
    emit(LoadingUserRetseptState());
    try {
      final retsepts = await _retseptRepository.getUserRetsepts();
      emit(LoadedUserRetseptState(retsepts: retsepts));
    } catch (e) {
      emit(ErrorUserRetseptState(message: e.toString()));
    }
  }
}
