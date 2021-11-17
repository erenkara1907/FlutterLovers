import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_lovers/src/model/user_model.dart';
import 'package:flutter_lovers/src/service/firebase_service/base/db_base.dart';

class DbService implements DbBase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserModel? _readUserField;

  @override
  Future<bool> saveUser(UserModel userModel) async {
    /* Map<String, dynamic> _addUserMap = userModel.toMap();
    _addUserMap['createdAt'] = FieldValue.serverTimestamp();
    _addUserMap['updatedAt'] = FieldValue.serverTimestamp();*/
    try {
      await _firestore
          .collection("users")
          .doc(userModel.userID)
          .set(userModel.toMap());

      return true;
    } catch (e) {
      throw Exception('DbService saveUser error : ' + e.toString());
    }
  }

  @override
  Future<UserModel> readUser(String userId) async {
    try {
      await _firestore.collection("users").doc(userId).get().then((result) {
        Map<String, dynamic>? _readUserMap = result.data();
        _readUserField = UserModel.fromMap(_readUserMap!);
      });
      print('Okunan user nesnesi: ' + _readUserField.toString());
      return _readUserField!;
    } catch (e) {
      throw Exception('DbService readUser error : ' + e.toString());
    }
  }

  @override
  Future<bool> updateUserName(String userId, String newUserName) async {
    var users = await _firestore
        .collection("users")
        .where("userName", isEqualTo: newUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firestore.collection("users").doc(userId).update({
        "userName": newUserName,
      });
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userId, String profilePhotoUrl) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .update({'photoUrl': profilePhotoUrl});
    return true;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> allUser = [];

    await _firestore.collection("users").get().then((querySnapshot) => {
          querySnapshot.docs.forEach((result) {
            UserModel _user = UserModel.fromMap(result.data());
            allUser.add(_user);
          }),
        });

    // Map Metodu ile;
    // allUser = querySnapshot.documents.map((_user)=>User.fromMap(_user.data)).toList();

    /*for(DocumentSnapshot user in querySnapshot.docs){
      UserModel _user = UserModel.fromMap(user.data);
    }*/
    return allUser;
  }
}
