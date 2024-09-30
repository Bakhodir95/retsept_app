class CategoriesModel {
  final String id;
  final String name;

  CategoriesModel({
    required this.id,
    required this.name,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      id: json["id"] ?? "",
      name: json["category-name"] ?? "",
    );
  }

  @override
  String toString() {
    return "id: $id, category-name: $name";
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category-name": name,
    };
  }
}
