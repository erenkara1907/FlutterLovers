import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lovers/src/locator.dart';
import 'package:flutter_lovers/src/model/user_model.dart';
import 'package:flutter_lovers/src/repository/user/user_repository.dart';
import 'package:flutter_lovers/src/service/firebase_service/base/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  final UserRepository _userRepository = locator<UserRepository>();

  ViewState _viewState = ViewState.Idle;
  UserModel? _userModel;

  UserModel? get userModel => _userModel!;

  ViewState get viewState => _viewState;

  String? emailErrorMessage;
  String? passwordErrorMessage;

  set viewState(ViewState value) {
    _viewState = value;
    notifyListeners();
  }

  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      viewState = ViewState.Busy;
      _userModel = await _userRepository.currentUser();
      return _userModel!;
    } catch (e) {
      viewState = ViewState.Idle;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInAnonymous() async {
    try {
      viewState = ViewState.Busy;
      _userModel = await _userRepository.signInAnonymous();
      return _userModel!;
    } catch (e) {
      return throw Exception(
          'Viewmodel signInAnonymous error : ' + e.toString());
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<bool?> signOut() async {
    try {
      viewState = ViewState.Busy;
      bool? result = await _userRepository.signOut();
      _userModel == null;
      return result;
    } catch (e) {
      return false;
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      viewState = ViewState.Busy;
      _userModel = await _userRepository.signInWithGoogle();
      return _userModel!;
    } catch (e) {
      return throw Exception(
          'Viewmodel signInWithGoogle error : ' + e.toString());
    } finally {
      viewState = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
      String email, String password) async {
    if (_emailAndPasswordControl(email, password)) {
      try {
        viewState = ViewState.Busy;
        _userModel = await _userRepository.createUserWithEmailAndPassword(
            email, password);
        return _userModel!;
      } finally {
        viewState = ViewState.Idle;
      }
    } else {
      throw Exception('UserViewmodel createUserWithEmailAndPassword error');
    }
  }

  bool _emailAndPasswordControl(String email, String password) {
    var sonuc = true;

    if (password.length < 6) {
      passwordErrorMessage = "En az 6 karakter olmalı";
      sonuc = false;
    } else
      passwordErrorMessage = null;
    if (!email.contains('@')) {
      emailErrorMessage = "Geçersiz email adresi";
      sonuc = false;
    } else
      emailErrorMessage = null;
    return sonuc;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    if (_emailAndPasswordControl(email, password)) {
      try {
        viewState = ViewState.Busy;
        _userModel =
            await _userRepository.signInWithEmailAndPassword(email, password);
        return _userModel!;
      } finally {
        viewState = ViewState.Idle;
      }
    } else {
      throw Exception('UserViewModel signWithEmailAndPassword error');
    }
  }

  Future<bool> updateUsername(String userId, String newUserName) async {
    var result = await _userRepository.updateUserName(userId, newUserName);
    if (result) {
      _userModel!.userName = newUserName;
    }
    return result;
  }

  Future<String> uploadFile(
      String? userID, String fileType, File? profilePhoto) async {
    var result =
        await _userRepository.uploadFile(userID, fileType, profilePhoto);
    return result;
  }

  Future<List<UserModel>> getAllUser() async {
    var allUserList = await _userRepository.getAllUser();
    return allUserList;
  }
}
