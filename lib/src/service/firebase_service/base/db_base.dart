import 'package:flutter_lovers/src/model/user_model.dart';

abstract class DbBase {
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel> readUser(String userId);
  Future<bool> updateUserName(String userId, String newUserName);
  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl);
  Future<List<UserModel>> getAllUsers();
}