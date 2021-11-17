import 'package:flutter_lovers/src/model/user_model.dart';

abstract class AuthBase {
  Future<UserModel?> currentUser();

  Future<UserModel?> signInAnonymous();

  Future<bool?> signOut();

  Future<UserModel?> signInWithGoogle();

  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> createUserWithEmailAndPassword(String email, String password);
}
