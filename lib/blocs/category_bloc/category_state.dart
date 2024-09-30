part of "category_bloc.dart";

sealed class CategoryState {}

final class InitialCategoryState extends CategoryState {}

final class LoadingCategoryState extends CategoryState {}

final class LoadedCategoryState extends CategoryState {
  List<CategoriesModel> categories;
  LoadedCategoryState({required this.categories});
}

final class ErrorCategoryState extends CategoryState {
  final String message;
  ErrorCategoryState({required this.message});
}
