import 'dart:io';
import 'package:flutter_lovers/src/locator.dart';
import 'package:flutter_lovers/src/model/user_model.dart';
import 'package:flutter_lovers/src/service/firebase_service/auth/auth_service.dart';
import 'package:flutter_lovers/src/service/firebase_service/auth/fake_auth_service.dart';
import 'package:flutter_lovers/src/service/firebase_service/base/auth_base.dart';
import 'package:flutter_lovers/src/service/firebase_service/database/firestore/db_service.dart';
import 'package:flutter_lovers/src/service/firebase_service/storage/firebase/storage_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final AuthService _authService = locator<AuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final DbService _dbService = locator<DbService>();
  final StorageService _storageService = locator<StorageService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      UserModel? _user = await _authService.currentUser();
      return await _dbService.readUser(_user!.userID!);
    }
  }

  @override
  Future<UserModel?> signInAnonymous() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymous();
    } else {
      return await _authService.signInAnonymous();
    }
  }

  @override
  Future<bool?> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _authService.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      UserModel? _user = await _authService.signInWithGoogle();
      bool _result = await _dbService.saveUser(_user!);
      if (_result) {
        return _user;
      } else {
        throw Exception('User not saved in database');
      }
    }
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailAndPassword(
          email, password);
    } else {
      UserModel? _user =
          await _authService.createUserWithEmailAndPassword(email, password);
      bool _result = await _dbService.saveUser(_user!);
      if (_result) {
        return await _dbService.readUser(_user.userID!);
      } else {
        throw Exception('User not saved in database');
      }
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailAndPassword(email, password);
    } else {
      UserModel? _user =
          await _authService.signInWithEmailAndPassword(email, password);

      return await _dbService.readUser(_user!.userID!);
    }
  }

  Future<bool> updateUserName(String userId, String newUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _dbService.updateUserName(userId, newUserName);
    }
  }

  Future<String> uploadFile(
      String? userId, String fileType, File? profilePhoto) async {
    if (appMode == AppMode.DEBUG) {
      return 'Download Url';
    } else {
      var profilePhotoUrl =
          await _storageService.uploadFile(userId, fileType, profilePhoto!);
      await _dbService.updateProfilePhoto(userId!, profilePhotoUrl);
      return profilePhotoUrl;
    }
  }

  Future<List<UserModel>> getAllUser() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      var allUserList = await _dbService.getAllUsers();
      return allUserList;
    }
  }
}
