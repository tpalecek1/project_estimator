/*
  Description: Implementation of the interface for Storage operations.
    The StorageInterface class sets up the prototypes for the methods used by
    the app for storing photos. These methods are designed to have universal
    names and to take-in/return built-in Dart types or instances of the
    UploadManager class (defined in this document), this way they are independent
    of the storage service used. The Storage class implements the StorageInterface
    methods, and the UploadManager class implements the UploadManagerInterface
    class, both using the Firebase Cloud Storage service. If ever the app wants
    to use a different storage service, then only the implementation of the
    Storage class and the UploadManager class need to be re-written with the
    new service's code, the rest of the app code using the storage code can
    remain the same.
    -Note 1: The code assumes that the app has internet connection. The
             app should check for internet connection prior to executing any
             storage method (or the storage code should be changed to deal with
             offline use somehow).
    -Note 2: The code doesn't check/process errors. Before production it should
             be re-worked to include error management.
    -Note 3: The storage operations of the app depend on the code in this
             document and also on code found in the app's Firebase Cloud
             Functions. The code in this document mainly deals with the upload
             of photos to storage, while the code in Cloud Functions deals
             with the deletion of photos from storage when the app updates or
             deletes photo related documents from the database (i.e. When a user
             is deleted, its avatar and all the room photos in all of his projects
             are removed from storage. When a project is deleted, all the room
             photos in the project are removed from storage. When a room is
             deleted, all its photos are removed from storage. And when a room
             photo is deleted, it is removed from storage).
  Collaborator(s): Genevieve B-Michaud
 */

import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project_estimator/services/auth.dart';

abstract class StorageInterface {
  Future<String> uploadAvatar(File image);
  Future<void> deleteAvatar(String url);
  Future<UploadManager> roomUploadManager(String roomId);
}

class Storage implements StorageInterface {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  static const String users = 'users';
  static const String rooms = 'rooms';

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

  Future<UploadManager> roomUploadManager(String roomId) async {  // roomId = Firestore Room document path
    String userId = await Auth().signedInUser();
    String pathPrefix = users + '/' + userId + '/' + rooms + '/' + roomId.split('/').last;  // Room document id from Room document path
    return UploadManager(_storage, pathPrefix);
  }
}




abstract class UploadManagerInterface {
  bool get isActive;
  int get uploadActiveCount;
  int get uploadTotalCount;
  Stream<UploadEvent> get uploadEvents;
  Stream<String> get uploadedUrls;

  void uploadFile(File file);
  void cancelUploads();
  void dispose();
}

class UploadEvent {
  final int bytesToUpload;
  final int bytesUploaded;

  UploadEvent(this.bytesToUpload, this.bytesUploaded);
}

class UploadManager implements UploadManagerInterface {
  final FirebaseStorage _storage;
  final String _filePrefix;
  List<UploadTask> _tasks;
  StreamController<UploadEvent> _uploadStreamCtl;
  StreamController<String> _uploadedStreamCtl;

  UploadManager(this._storage, this._filePrefix) {
    this._tasks = List<UploadTask>();
    this._uploadStreamCtl = StreamController<UploadEvent>.broadcast(onListen: _uploadStatus);
    this._uploadedStreamCtl = StreamController<String>.broadcast();
  }

  bool get isActive => uploadActiveCount > 0;
  int get uploadActiveCount => (_tasks.where((UploadTask task) => !task.isComplete && !task.isCanceled)).length;
  int get uploadTotalCount => _tasks.length;
  Stream<UploadEvent> get uploadEvents => _uploadStreamCtl.stream;
  Stream<String> get uploadedUrls => _uploadedStreamCtl.stream;

  void _uploadStatus() {
    if (uploadActiveCount == 0) {
      _tasks = List<UploadTask>();
    }

    if (uploadTotalCount > 0) {
      int bytesToUpload = 0;
      int bytesUploaded = 0;
      _tasks.forEach((UploadTask task) {
        bytesToUpload += task.bytesToUpload;
        bytesUploaded += task.bytesUploaded;
      });
      _uploadStreamCtl.add(UploadEvent(bytesToUpload, bytesUploaded));
    }
  }

  void uploadFile(File file) {
    String path = _filePrefix + '/' + DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference ref = _storage.ref().child(path);
    StorageUploadTask uploadTask = ref.putFile(file);
    UploadTask task = UploadTask(task: uploadTask);
    _tasks.add(task);

    uploadTask.events.listen((StorageTaskEvent event) async {
      if (event.snapshot != null) {
        task.bytesToUpload = event.snapshot.totalByteCount;
        task.bytesUploaded = event.snapshot.bytesTransferred;
        task.isComplete = uploadTask.isComplete;
        task.isCanceled = uploadTask.isCanceled;

        _uploadStatus();

        if (task.isComplete && !task.isCanceled) {
          String url = await ref.getDownloadURL();
          _uploadedStreamCtl.add(url.toString());
        }
      }
    });
  }

  void cancelUploads() {
    _tasks.forEach((UploadTask uploadTask) {
      if (!uploadTask.isComplete && !uploadTask.isCanceled) {
        uploadTask.task.cancel();
      }
    });
    _tasks = List<UploadTask>();
  }

  void dispose() {
    _uploadStreamCtl.close();
    _uploadedStreamCtl.close();
  }
}

class UploadTask {
  final StorageUploadTask task;
  int bytesToUpload;
  int bytesUploaded;
  bool isComplete;
  bool isCanceled;

  UploadTask({
    this.task,
    this.bytesToUpload = 0,
    this.bytesUploaded = 0,
    this.isComplete = false,
    this.isCanceled = false});
}