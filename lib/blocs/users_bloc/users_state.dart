import 'package:equatable/equatable.dart';
import 'package:retsept_app/data/models/user_model.dart';

abstract class UsersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UserAdded extends UsersState {
  final UserModels user;

  UserAdded(this.user);

  @override
  List<Object?> get props => [user];
}

class AuthenticatedUserLoaded extends UsersState {
  final UserModels user;

  AuthenticatedUserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UsersError extends UsersState {
  final String message;

  UsersError(this.message);

  @override
  List<Object?> get props => [message];
}
