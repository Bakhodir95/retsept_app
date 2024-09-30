class User {
  final String id;
  final String email;
  final String token;
  final String refreshToken;
  final DateTime expiresIn;

  User({
    required this.id,
    required this.email,
    required this.token,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory User.fromJson(Map<String, dynamic> json) {
  final expiresIn = json['expiresIn'] ?? '0'; // Default qiymat qo'shish
  return User(
    id: json['localId'] ?? '',
    email: json['email'] ?? '',
    token: json['idToken'] ?? '',
    refreshToken: json['refreshToken'] ?? '',
    expiresIn: DateTime.now().add(
      Duration(seconds: int.tryParse(expiresIn) ?? 0), // `int.tryParse` ishlatish
    ),
  );
}


  Map<String, dynamic> toJson() {
    return {
      'localId': id,
      'email': email,
      'idToken': token,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn.toIso8601String(),
    };
  }
}
