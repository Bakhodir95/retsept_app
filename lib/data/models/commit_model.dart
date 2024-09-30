class CommitModel {
  String userId;
  String commit;

  CommitModel({
    required this.commit,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'userUid': userId,
      'commit': commit,
    };
  }

  factory CommitModel.fromMap(Map<String, dynamic> map) {
    return CommitModel(
      userId: map['userId'] ?? '',
      commit: map['commit'] ?? '',
    );
  }
}
