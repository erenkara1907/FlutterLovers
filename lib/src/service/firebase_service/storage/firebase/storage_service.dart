import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_lovers/src/service/firebase_service/base/storage_base.dart';

class StorageService implements StorageBase {
  final firebase_storage.FirebaseStorage _firebaseStorage =
      firebase_storage.FirebaseStorage.instance;

  @override
  Future<String> uploadFile(String? userId, String fileType, File file) async {
    var _storageReference =
        _firebaseStorage.ref().child(userId!).child(fileType).child('profile_photo.png');
    var uploadTask = _storageReference.putFile(file);

    var url = await (await uploadTask.snapshot).ref.getDownloadURL();

    return url;
  }
}
