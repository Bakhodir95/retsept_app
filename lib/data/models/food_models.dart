import 'package:retsept_app/data/models/commit_model.dart';
import 'package:retsept_app/data/models/ingredient_model.dart';

class Food {
  String id;
  String title;
  String userId;
  int likes;
  String imageUrl;
  String videoUrl;
  int cookingTime;
  List<IngredientModel> ingredients;
  List<CommitModel> commits;
  String categoryId;

  Food({
    required this.id,
    required this.title,
    required this.userId,
    required this.likes,
    required this.commits,
    required this.videoUrl,
    required this.categoryId,
    required this.cookingTime,
    required this.imageUrl,
    required this.ingredients,
  });

  // toMap() funksiyasi
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'userId': userId,
      'likes': likes,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'cookingTime': cookingTime,
      'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(),
      'commits': commits.map((commit) => commit.toMap()).toList(),
      'categoryId': categoryId,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      userId: map['userId'] ?? '',
      likes: map['likes'] is int
          ? map['likes']
          : int.tryParse(map['likes'] ?? '0') ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      categoryId: map['categoryId'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      ingredients: List<IngredientModel>.from(map['ingredients']?.map((ingredient) => IngredientModel.fromMap(ingredient)) ?? []),
      cookingTime: map["cookingTime"] ?? 0,
      commits: List<CommitModel>.from(map['commits']?.map((commit) => CommitModel.fromMap(commit)) ?? []),
    );
  }

  @override
  String toString() {
    return 'Food{id: $id, title: $title, imageUrl: $imageUrl, videoUrl: $videoUrl, cookingTime: $cookingTime, ingredients: $ingredients, commits: $commits}';
  }
}
