import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retsept_app/blocs/users_bloc/users_event.dart';
import 'package:retsept_app/blocs/users_bloc/users_state.dart';
import 'package:retsept_app/data/models/user_model.dart';
import 'package:retsept_app/data/repositories/users_repository.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final UsersRepository usersRepository;

  UsersBloc({required this.usersRepository}) : super(UsersInitial()) {
    on<AddUserEvent>(_onAddUser);
    on<GetAuthenticatedUserEvent>(_onGetAuthenticatedUser);
  }

  Future<void> _onAddUser(AddUserEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      await usersRepository.addUser(event.userName, event.imageUrl);
      final user = UserModels(userName: event.userName, imageUrl: event.imageUrl, id: '');
      emit(UserAdded(user));
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }

  Future<void> _onGetAuthenticatedUser(GetAuthenticatedUserEvent event, Emitter<UsersState> emit) async {
    emit(UsersLoading());
    try {
      final user = await usersRepository.getAuthenticatedUser();
      if (user != null) {
        emit(AuthenticatedUserLoaded(user));
      } else {
        emit(UsersError('No authenticated user found'));
      }
    } catch (e) {
      emit(UsersError(e.toString()));
    }
  }
}

