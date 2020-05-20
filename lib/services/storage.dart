import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_estimator/services/auth.dart';

abstract class StorageInterface {
  Future<String> uploadAvatar(File image);
  Future<void> deleteAvatar(String url);
}

class Storage implements StorageInterface {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const String users = 'users';

  Future<String> uploadAvatar(File image) async {
    String userId = await Auth().signedInUser();
    String path = users + '/' + userId + '/avatar/' + DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference ref = _storage.ref().child(path);
    StorageUploadTask uploadTask = ref.putFile(image);
    await uploadTask.onComplete;
    String url = await ref.getDownloadURL();
    return url.toString();
  }

  Future<void> deleteAvatar(String url) async {
    StorageReference ref = await _storage.getReferenceFromUrl(url);
    await ref.delete();
  }
}