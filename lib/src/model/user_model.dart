import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userID;
  String? email;
  String? userName;
  String? photoUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;

  UserModel({
    this.userID,
    this.email,
    this.userName,
    this.photoUrl,
    this.createdAt,
    this.updatedAt,
    this.level,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userID,
      'email': email,
      'userName': userName ??
          email!.substring(0, email!.indexOf('@')) + generateRandomNumber(),
      'photoUrl': photoUrl ??
          'https://thumbs.dreamstime.com/b/handsome-man-black-suit-white-shirt-posing-studio-attractive-guy-fashion-hairstyle-confident-man-short-beard-125019349.jpg',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userID = map['userId'],
        email = map['email'],
        userName = map['userName'],
        photoUrl = map['photoUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        level = map['level'];

  @override
  String toString() {
    return 'UserModel{userID: $userID, email: $email, userName: $userName, photoUrl: $photoUrl, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }

  String generateRandomNumber() {
    int randomNumber = Random().nextInt(999999);
    return randomNumber.toString();
  }
}
