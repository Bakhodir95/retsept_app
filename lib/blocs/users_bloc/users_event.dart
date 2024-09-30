import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddUserEvent extends UsersEvent {
  final String userName;
  final String imageUrl;

  AddUserEvent(this.userName, this.imageUrl);

  @override
  List<Object?> get props => [userName, imageUrl];
}

class GetAuthenticatedUserEvent extends UsersEvent {}
