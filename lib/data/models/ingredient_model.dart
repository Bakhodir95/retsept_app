class IngredientModel {
  String title;
  String amount;

  IngredientModel({
    required this.amount,
    required this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
    };
  }

  factory IngredientModel.fromMap(Map<String, dynamic> map) {
    return IngredientModel(
      title: map['title'] ?? '',
      amount: map['amount'] ?? '',
    );
  }

  @override
  String toString() {
    return 'IngredientModel{title: $title, amount: $amount}';
  }
}
