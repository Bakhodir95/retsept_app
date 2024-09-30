// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModels {
  String userName;
  String imageUrl;
  String id;
  List<UserModels> followers;
  List<UserModels> follows;


  UserModels({
    required this.userName,
    required this.imageUrl,
    required this.id,
    this.followers = const [],
    this.follows = const [],
  });



  UserModels copyWith({
    String? userName,
    String? imageUrl,
    String? id,
    List<UserModels>? followers,
    List<UserModels>? follows,
  }) {
    return UserModels(
      userName: userName ?? this.userName,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      followers: followers ?? this.followers,
      follows: follows ?? this.follows,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'imageUrl': imageUrl,
      'id': id,
      'followers': followers.map((x) => x.toMap()).toList(),
      'follows': follows.map((x) => x.toMap()).toList(),
    };
  }

  factory UserModels.fromMap(Map<String, dynamic> map) {
    return UserModels(
      userName: map['userName'] as String,
      imageUrl: map['imageUrl'] as String,
      id: map['id'] as String,
      followers: List<UserModels>.from((map['followers'] as List<int>).map<UserModels>((x) => UserModels.fromMap(x as Map<String,dynamic>),),),
      follows: List<UserModels>.from((map['follows'] as List<int>).map<UserModels>((x) => UserModels.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModels.fromJson(String source) => UserModels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModels(userName: $userName, imageUrl: $imageUrl, id: $id, followers: $followers, follows: $follows)';
  }

  @override
  bool operator ==(covariant UserModels other) {
    if (identical(this, other)) return true;
  
    return 
      other.userName == userName &&
      other.imageUrl == imageUrl &&
      other.id == id &&
      listEquals(other.followers, followers) &&
      listEquals(other.follows, follows);
  }

  @override
  int get hashCode {
    return userName.hashCode ^
      imageUrl.hashCode ^
      id.hashCode ^
      followers.hashCode ^
      follows.hashCode;
  }
}
