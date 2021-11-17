import 'package:flutter_lovers/src/model/user_model.dart';
import 'package:flutter_lovers/src/service/firebase_service/base/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userId = '123321';

  @override
  Future<UserModel> currentUser() async {
    return await Future.value(
        UserModel(userID: userId, email: 'FakeUser@fake.com'));
  }

  @override
  Future<UserModel> signInAnonymous() async {
    return await Future.delayed(const Duration(seconds: 2),
        () => UserModel(userID: userId, email: 'FakeUser@fake.com'));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    return await Future.delayed(
        const Duration(seconds: 2),
        () => UserModel(
            userID: 'google_user_id_001', email: 'FakeUser@fake.com'));
  }

  @override
  Future<UserModel> createUserWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
        const Duration(seconds: 2),
        () => UserModel(
            userID: 'create_user_id_001', email: 'FakeUser@fake.com'));
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    return await Future.delayed(
        const Duration(seconds: 2),
        () =>
            UserModel(userID: 'sign_user_id_001', email: 'FakeUser@fake.com'));
  }
}
