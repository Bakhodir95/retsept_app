import 'package:retsept_app/data/models/food_models.dart';

sealed class UserRetseptState {}

final class InitialUserRetseptState extends UserRetseptState {}

final class LoadingUserRetseptState extends UserRetseptState {}

final class LoadedUserRetseptState extends UserRetseptState {
  final List<Food> retsepts;
  LoadedUserRetseptState({required this.retsepts});
}

final class ErrorUserRetseptState extends UserRetseptState {
  final String message;
  ErrorUserRetseptState({required this.message});
}
