import 'package:retsept_app/data/models/commit_model.dart';
import 'package:retsept_app/data/models/ingredient_model.dart';

sealed class RetseptEvent {}

final class GetRetseptsEvent extends RetseptEvent {}


final class AddRetseptEvent extends RetseptEvent {
  final String title;
  final String userId;
  final int likes;
  final String imageUrl;
  final String videoUrl;
  final int cookingTime;
  final List<IngredientModel> ingredients;
  final List<CommitModel> commits;
  final String categoryId;

  AddRetseptEvent({
    required this.title,
    required this.userId,
    required this.likes,
    required this.imageUrl,
    required this.videoUrl,
    required this.cookingTime,
    required this.ingredients,
    required this.commits,
    required this.categoryId,
  });
}

class EditRetseptEvent extends RetseptEvent {
  final String retseptId;
  final String userId; // Added userId field
  final String title;
  final int likes;
  final String imageUrl;
  final String videoUrl;
  final int cookingTime;
  final List<IngredientModel> ingredients;
  final String categoryId;

  EditRetseptEvent({
    required this.retseptId,
    required this.userId, // Initialize userId
    required this.title,
    required this.likes,
    required this.imageUrl,
    required this.videoUrl,
    required this.cookingTime,
    required this.ingredients,
    required this.categoryId,
  });

  List<Object> get props => [
        retseptId,
        userId, // Add userId to props
        title,
        likes,
        imageUrl,
        videoUrl,
        cookingTime,
        ingredients,
        categoryId,
      ];
}



final class DeleteRetseptEvent extends RetseptEvent {
  final String id;
  DeleteRetseptEvent({required this.id});
}


