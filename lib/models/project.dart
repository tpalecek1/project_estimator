import 'room.dart';
import 'project_note.dart';
import 'estimate.dart';

class Project {
  String name, status, description, clientName, clientAddress, clientPhoneNumber;
  DateTime date;
  List<Room> rooms;
  List<ProjectNote> projectNotes;
  List<Estimate> estimates;

  Project({
    this.name = "",
    this.status = "not bid",
    this.description = "",
    this.clientName = "",
    this.clientAddress = "",
    this.clientPhoneNumber = "",
    this.date,
    this.rooms,
    this.projectNotes,
    this.estimates,
  });

  Project.fromMap(dynamic map){
    name = map['name'];
    status = map["status"];
    description = map["description"];
    clientName = map['clientName'];
    clientAddress = map['clientAddress'];
    clientPhoneNumber = map['clientPhoneNumber'];
    date = map['date'];
    rooms = map['rooms'];
    projectNotes = map['projectNotes'];
    estimates = map['estimates'];
  }

  void addRoom(Room room){
    //todo - Add room to database
    rooms.add(room);
  }

  void addEstimate(Estimate estimate){
    //todo - Add estimate to database
    estimates.add(estimate);
  }

  void addNote(ProjectNote note){
    //todo - Add Note to database
    projectNotes.add(note);
  }

  void removeRoom(Room room){
    //todo - Remove room from database
    rooms.remove(room);
  }

  void removeEstimate(Estimate estimate){
    //todo - Remove estimate from database
    estimates.remove(estimate);
  }

  void removeNote(ProjectNote note){
    //todo - Remove note from database
    projectNotes.remove(note);
  }

}