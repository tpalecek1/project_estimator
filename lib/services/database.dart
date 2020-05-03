/*
  Description: Implementation of the interface for Database operations.
    The DatabaseInterface class sets up the prototypes for the methods used by
    the app for database queries. These methods are designed to have universal
    names and to take-in/return built-in Dart types or instances of the app's
    data models, this way they are independent of the type of database used.
    The Database class implements the DatabaseInterface methods with the
    Firebase Firestore NoSQL service. If ever the app wants to use a different
    database service, then only the implementation of each method in the
    Database class need to be re-written with the new service's code, the rest
    of the app code using the database code can remain the same.
    Note: in normal circumstances/use the Firestore queries shouldn't cause any
    errors, but if a rare case (like a Firestore system or communication error)
    were to happen, the methods in the Database class rethrow the Firestore
    errors (for clarity that an error could potentially propagate to the calling
    code).
  Collaborator(s): Genevieve B-Michaud
 */

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:project_estimator/models/user.dart';
import 'package:project_estimator/models/project.dart';
import 'package:project_estimator/models/project_note.dart';
import 'package:project_estimator/models/room.dart';
import 'package:project_estimator/models/room_note.dart';
import 'package:project_estimator/models/estimate.dart';

abstract class DatabaseInterface {
  // users
  Future<void> createUser(User user);
  Future<User> readUser(String userId);
  //Future<List<User>> readUsers();
  Future<void> updateUser(User user);
  Future<void> deleteUser(String userId);

  // projects
  Future<void> createProject(String userId, Project project);
  Future<Project> readProject(String projectId);
  Future<List<Project>> readProjects(String userId);
  Stream<List<Project>> readProjectsRealTime(String userId);
  Future<void> updateProject(Project project);
  Future<void> deleteProject(String projectId);

  // projectNotes
  Future<void> createProjectNote(String projectId, ProjectNote note);
  Future<ProjectNote> readProjectNote(String projectNoteId);
  Future<List<ProjectNote>> readProjectNotes(String projectId);
  Stream<List<ProjectNote>> readProjectNotesRealTime(String projectId);
  Future<List<ProjectNote>> readProjectNotesWithCost(String projectId);
  Future<void> updateProjectNote(ProjectNote note);
  Future<void> deleteProjectNote(String projectNoteId);

  // rooms
  Future<void> createRoom(String projectId, Room room);
  Future<Room> readRoom(String roomId);
  Future<List<Room>> readRooms(String projectId);
  Stream<List<Room>> readRoomsRealTime(String projectId);
  Future<void> updateRoom(Room room);
  Future<void> deleteRoom(String roomId);

  // roomNotes
  Future<void> createRoomNote(String roomId, RoomNote note);
  Future<RoomNote> readRoomNote(String roomNoteId);
  Future<List<RoomNote>> readRoomNotes(String roomId);
  Stream<List<RoomNote>> readRoomNotesRealTime(String roomId);
  Future<List<RoomNote>> readRoomNotesWithCost(String roomId);
  Future<void> updateRoomNote(RoomNote note);
  Future<void> deleteRoomNote(String roomNoteId);

  // estimates
  Future<void> createEstimate(String projectId, Estimate estimate);
  Future<Estimate> readEstimate(String estimateId);
  Future<List<Estimate>> readEstimates(String projectId);
  Stream<List<Estimate>> readEstimatesRealTime(String projectId);
  Future<void> updateEstimate(Estimate estimate);
  Future<void> deleteEstimate(String estimateId);
}

class Database implements DatabaseInterface {
  final Firestore _db = Firestore.instance;
  final HttpsCallable _recursiveDelete = CloudFunctions.instance.getHttpsCallable(functionName: 'recursiveDelete');

  // database collection and sub-collection names
  static const String users = 'users';
  static const String projects = 'projects';
  static const String projectNotes = 'projectNotes';
  static const String rooms = 'rooms';
  static const String roomNotes = 'roomNotes';
  static const String estimates = 'estimates';



  // users  (user.id and userId = auth uid)
  Future<void> createUser(User user) async {
    try {
      await _db.collection(users).document(user.id).setData(user.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<User> readUser(String userId) async {
    DocumentSnapshot doc;

    try {
      doc = await _db.collection(users).document(userId).get();
    }
    catch (error) {
      rethrow;
    }

    return doc.exists ? User.fromMap(doc.data, doc.documentID) : null;
  }

  Future<void> updateUser(User user) async {
    try {
      await _db.collection(users).document(user.id).updateData(user.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _recursiveDelete({ 'path': users + '/' + userId });
    }
    catch (error) {
      rethrow;
    }
  }



  // projects  (userId = auth uid, projectId and project.id = project doc path)
  Future<void> createProject(String userId, Project project) async {
    try {
      await _db.collection(users).document(userId).collection(projects).document().setData(project.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<Project> readProject(String projectId) async {
    DocumentSnapshot doc;

    try{
      doc = await _db.document(projectId).get();
    }
    catch (error) {
      rethrow;
    }

    return doc.exists ? Project.fromMap(doc.data, doc.reference.path) : null;
  }

  Future<List<Project>> readProjects(String userId) async {
    QuerySnapshot query;

    try {
      query = await _db.collection(users).document(userId).collection(projects).getDocuments();
    }
    catch (error) {
      rethrow;
    }

    return query.documents.map((doc) => Project.fromMap(doc.data, doc.reference.path)).toList();
  }

  Stream<List<Project>> readProjectsRealTime(String userId) {
    StreamController<List<Project>> projectStreamCtl;
    StreamSubscription projectStreamSub;

    void listenForProjects() {
      projectStreamSub = _db.collection(users).document(userId).collection(projects).snapshots().listen((snapshot) {
        if (snapshot.documents.isNotEmpty) {
          List<Project> docs = snapshot.documents.map((doc) => Project.fromMap(doc.data, doc.reference.path)).toList();
          projectStreamCtl.add(docs);
        }
      });
    }

    void stopListeningForProjects() {
      projectStreamSub.cancel();
      projectStreamCtl.close();
    }

    projectStreamCtl = StreamController<List<Project>>.broadcast(
      onListen: listenForProjects,
      onCancel: stopListeningForProjects
    );

    return projectStreamCtl.stream;
  }

  Future<void> updateProject(Project project) async {
    try {
      await _db.document(project.id).updateData(project.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      //await _db.document(projectId).delete();
      await _recursiveDelete.call({ 'path': projectId });
    }
    catch (error) {
      rethrow;
    }
  }



  // projectNotes  (projectId = project doc path, projectNoteId and note.id = projectNote doc path)
  Future<void> createProjectNote(String projectId, ProjectNote note) async {
    try {
      await _db.document(projectId).collection(projectNotes).document().setData(note.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<ProjectNote> readProjectNote(String projectNoteId) async {
    DocumentSnapshot doc;

    try {
      doc = await _db.document(projectNoteId).get();
    }
    catch (error) {
      rethrow;
    }

    return doc.exists ? ProjectNote.fromMap(doc.data, doc.reference.path) : null;
  }

  Future<List<ProjectNote>> readProjectNotes(String projectId) async {
    QuerySnapshot query;

    try {
      query = await _db.document(projectId).collection(projectNotes).getDocuments();
    }
    catch (error) {
      rethrow;
    }

    return query.documents.map((doc) => ProjectNote.fromMap(doc.data, doc.reference.path)).toList();
  }

  Stream<List<ProjectNote>> readProjectNotesRealTime(String projectId) {
    StreamController<List<ProjectNote>> projectNoteStreamCtl;
    StreamSubscription projectNoteStreamSub;

    void listenForProjectNotes() {
      projectNoteStreamSub = _db.document(projectId).collection(projectNotes).snapshots().listen((snapshot) {
        if (snapshot.documents.isNotEmpty) {
          List<ProjectNote> docs = snapshot.documents.map((doc) => ProjectNote.fromMap(doc.data, doc.reference.path)).toList();
          projectNoteStreamCtl.add(docs);
        }
      });
    }

    void stopListeningForProjectNotes() {
      projectNoteStreamSub.cancel();
      projectNoteStreamCtl.close();
    }

    projectNoteStreamCtl = StreamController<List<ProjectNote>>.broadcast(
        onListen: listenForProjectNotes,
        onCancel: stopListeningForProjectNotes
    );

    return projectNoteStreamCtl.stream;
  }

  Future<List<ProjectNote>> readProjectNotesWithCost(String projectId) async {
    QuerySnapshot query;

    try {
      query = await _db.document(projectId).collection(projectNotes).where('hasCost', isEqualTo: true).getDocuments();
    }
    catch (error) {
      rethrow;
    }

    return query.documents.map((doc) => ProjectNote.fromMap(doc.data, doc.reference.path)).toList();
  }

  Future<void> updateProjectNote(ProjectNote note) async {
    try {
      await _db.document(note.id).updateData(note.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<void> deleteProjectNote(String projectNoteId) async {
    try {
      await _db.document(projectNoteId).delete();
    }
    catch (error) {
      rethrow;
    }
  }



  // rooms  (projectId = project doc path, roomId and room.id = room doc path)
  Future<void> createRoom(String projectId, Room room) async {
    try {
      await _db.document(projectId).collection(rooms).document().setData(room.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<Room> readRoom(String roomId) async {
    DocumentSnapshot doc;

    try {
      doc = await _db.document(roomId).get();
    }
    catch (error) {
      rethrow;
    }

    return doc.exists ? Room.fromMap(doc.data, doc.reference.path) : null;
  }

  Future<List<Room>> readRooms(String projectId) async {
    QuerySnapshot query;

    try {
      query = await _db.document(projectId).collection(rooms).getDocuments();
    }
    catch (error) {
      rethrow;
    }

    return query.documents.map((doc) => Room.fromMap(doc.data, doc.reference.path)).toList();
  }

  Stream<List<Room>> readRoomsRealTime(String projectId) {
    StreamController<List<Room>> roomStreamCtl;
    StreamSubscription roomStreamSub;

    void listenForRooms() {
      roomStreamSub = _db.document(projectId).collection(rooms).snapshots().listen((snapshot) {
        if (snapshot.documents.isNotEmpty) {
          List<Room> docs = snapshot.documents.map((doc) => Room.fromMap(doc.data, doc.reference.path)).toList();
          roomStreamCtl.add(docs);
        }
      });
    }

    void stopListeningForRooms() {
      roomStreamSub.cancel();
      roomStreamCtl.close();
    }

    roomStreamCtl = StreamController<List<Room>>.broadcast(
        onListen: listenForRooms,
        onCancel: stopListeningForRooms
    );

    return roomStreamCtl.stream;
  }

  Future<void> updateRoom(Room room) async {
    try {
      await _db.document(room.id).updateData(room.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<void> deleteRoom(String roomId) async {
    try {
      //await _db.document(roomId).delete();
      await _recursiveDelete.call({ 'path': roomId });
    }
    catch (error) {
      rethrow;
    }
  }



  // roomNotes  (roomId = room doc path, roomNoteId and note.id = roomNote doc path)
  Future<void> createRoomNote(String roomId, RoomNote note) async {
    try {
      await _db.document(roomId).collection(roomNotes).document().setData(note.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<RoomNote> readRoomNote(String roomNoteId) async {
    DocumentSnapshot doc;

    try {
      doc = await _db.document(roomNoteId).get();
    }
    catch (error) {
      rethrow;
    }

    return doc.exists ? RoomNote.fromMap(doc.data, doc.reference.path) : null;
  }

  Future<List<RoomNote>> readRoomNotes(String roomId) async {
    QuerySnapshot query;

    try {
      query = await _db.document(roomId).collection(roomNotes).getDocuments();
    }
    catch (error) {
      rethrow;
    }

    return query.documents.map((doc) => RoomNote.fromMap(doc.data, doc.reference.path)).toList();
  }

  Stream<List<RoomNote>> readRoomNotesRealTime(String roomId) {
    StreamController<List<RoomNote>> roomNoteStreamCtl;
    StreamSubscription roomNoteStreamSub;

    void listenForRoomNotes() {
      roomNoteStreamSub = _db.document(roomId).collection(roomNotes).snapshots().listen((snapshot) {
        if (snapshot.documents.isNotEmpty) {
          List<RoomNote> docs = snapshot.documents.map((doc) => RoomNote.fromMap(doc.data, doc.reference.path)).toList();
          roomNoteStreamCtl.add(docs);
        }
      });
    }

    void stopListeningForRoomNotes() {
      roomNoteStreamSub.cancel();
      roomNoteStreamCtl.close();
    }

    roomNoteStreamCtl = StreamController<List<RoomNote>>.broadcast(
        onListen: listenForRoomNotes,
        onCancel: stopListeningForRoomNotes
    );

    return roomNoteStreamCtl.stream;
  }

  Future<List<RoomNote>> readRoomNotesWithCost(String roomId) async {
    QuerySnapshot query;

    try {
      query = await _db.document(roomId).collection(roomNotes).where('hasCost', isEqualTo: true).getDocuments();
    }
    catch (error) {
      rethrow;
    }

    return query.documents.map((doc) => RoomNote.fromMap(doc.data, doc.reference.path)).toList();
  }

  Future<void> updateRoomNote(RoomNote note) async {
    try {
      await _db.document(note.id).updateData(note.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<void> deleteRoomNote(String roomNoteId) async {
    try {
      await _db.document(roomNoteId).delete();
    }
    catch (error) {
      rethrow;
    }
  }



  // estimates  (projectId = project doc path, estimateId and estimate.id = estimate doc path)
  Future<void> createEstimate(String projectId, Estimate estimate) async {
    try {
      await _db.document(projectId).collection(estimates).document().setData(estimate.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<Estimate> readEstimate(String estimateId) async {
    DocumentSnapshot doc;

    try {
      doc = await _db.document(estimateId).get();
    }
    catch (error) {
      rethrow;
    }

    return doc.exists ? Estimate.fromMap(doc.data, doc.reference.path) : null;
  }

  Future<List<Estimate>> readEstimates(String projectId) async {
    QuerySnapshot query;

    try {
      query = await _db.document(projectId).collection(estimates).getDocuments();
    }
    catch (error) {
      rethrow;
    }

    return query.documents.map((doc) => Estimate.fromMap(doc.data, doc.reference.path)).toList();
  }

  Stream<List<Estimate>> readEstimatesRealTime(String projectId) {
    StreamController<List<Estimate>> estimateStreamCtl;
    StreamSubscription estimateStreamSub;

    void listenForEstimates() {
      estimateStreamSub = _db.document(projectId).collection(estimates).snapshots().listen((snapshot) {
        if (snapshot.documents.isNotEmpty) {
          List<Estimate> docs = snapshot.documents.map((doc) => Estimate.fromMap(doc.data, doc.reference.path)).toList();
          estimateStreamCtl.add(docs);
        }
      });
    }

    void stopListeningForEstimates() {
      estimateStreamSub.cancel();
      estimateStreamCtl.close();
    }

    estimateStreamCtl = StreamController<List<Estimate>>.broadcast(
        onListen: listenForEstimates,
        onCancel: stopListeningForEstimates
    );

    return estimateStreamCtl.stream;
  }

  Future<void> updateEstimate(Estimate estimate) async {
    try {
      await _db.document(estimate.id).updateData(estimate.toMap());
    }
    catch (error) {
      rethrow;
    }
  }

  Future<void> deleteEstimate(String estimateId) async {
    try {
      await _db.document(estimateId).delete();
    }
    catch (error) {
      rethrow;
    }
  }
}