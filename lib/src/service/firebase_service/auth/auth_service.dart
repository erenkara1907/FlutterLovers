import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_lovers/src/model/user_model.dart';
import 'package:flutter_lovers/src/service/firebase_service/base/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService implements AuthBase {
  User? user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<UserModel?> currentUser() async {
    user = await auth.currentUser;
    return _userFromFirebase(user);
  }

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null!;
    }else {
      return UserModel(userID: user.uid, email: user.email);
    }
  }

  @override
  Future<UserModel?> signInAnonymous() async {
    UserCredential result = await auth.signInAnonymously();
    return _userFromFirebase(result.user);
  }

  @override
  Future<bool?> signOut() async {
    final _googleSignIn = GoogleSignIn();
    await _googleSignIn.signOut();
    await auth.signOut();
    return true;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential result = await auth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: _googleAuth.idToken,
            accessToken: _googleAuth.accessToken,
          ),
        );

        User? _user = result.user;
        return _userFromFirebase(_user);
      } else {
        throw UnimplementedError();
      }
    } else {
      throw UnimplementedError();
    }
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(result.user);
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(result.user);
  }
}
