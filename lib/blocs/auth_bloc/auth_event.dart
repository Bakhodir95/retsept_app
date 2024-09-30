part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;

  RegisterEvent({required this.email, required this.password});
}

class ForgotPassword extends AuthEvent {
  final String email;
  ForgotPassword({required this.email});
}

class LogoutEvent extends AuthEvent {}

class CheckTokenExpiryEvent extends AuthEvent {}

class GoogleSignInEvent extends AuthEvent {}
