part of "category_bloc.dart";

sealed class CategoryEvent {}

final class GetCategoryEvent extends CategoryEvent {}

final class AddCategoryEvent extends CategoryEvent {
  final String name;
  AddCategoryEvent({required this.name});
}

