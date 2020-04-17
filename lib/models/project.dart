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
    this.name,
    this.status = "not bid",
    this.description,
    this.clientName,
    this.clientAddress,
    this.clientPhoneNumber,
    this.date,
    this.rooms,
    this.projectNotes,
    this.estimates,
  });

  Project.fromMap(dynamic map){
    
  }

}