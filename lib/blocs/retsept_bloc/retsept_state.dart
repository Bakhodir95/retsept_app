import 'package:retsept_app/data/models/food_models.dart';

sealed class RetseptState {}

final class InitialRetseptState extends RetseptState {}

final class LoadingRetseptState extends RetseptState {}

final class LoadedRetseptState extends RetseptState {
  final List<Food> retsepts;
  LoadedRetseptState({required this.retsepts});
}

final class ErrorRetseptState extends RetseptState {
  final String message;
  ErrorRetseptState({required this.message});
}
