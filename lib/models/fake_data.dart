import 'project.dart';
import 'room.dart';
import 'user.dart';
import 'project_note.dart';
import 'room_note.dart';

class FakeData{
  List<Project> projects = [];
  List<Room> rooms = [];
  List<ProjectNote> projectNotes = [];
  List<RoomNote> roomNotes = [];

  FakeData(){
    projects.add(Project(
      id: 0, 
      name: 'Project 1',
      status: 'not bid',
      description: 'New House Painting',
      clientName: 'Jim',
      clientAddress: '1234 Main St.',
      clientPhoneNumber: '(555)123-4567',
      date: DateTime.now(),
      )
    );
    projects.add(Project(
      id: 1, 
      name: 'Project 2',
      status: 'bid',
      description: 'Interior Painting',
      clientName: 'Dwight',
      clientAddress: '1010 Olive Ave.',
      clientPhoneNumber: '(555)123-4567',
      date: DateTime.now(),
      )
    );
    projects.add(Project(
      id: 2, 
      name: 'Project 3',
      status: 'complete',
      description: 'Painting Garage',
      clientName: 'Carol',
      clientAddress: '554 2nd St.',
      clientPhoneNumber: '(555)123-4567',
      date: DateTime.now(),
      )
    );
    rooms.add(Room(id: 0, name: 'Master Bedroom', ceilingHeight: 10, length: 12, width: 12, doorCount: 1, windowCount: 2, accentWallCount: 1, hasBaseboard: true));
    rooms.add(Room(id: 1, name: 'Bathroom', ceilingHeight: 8, length: 10, width: 9, doorCount: 1, windowCount: 3, accentWallCount: 0));
    rooms.add(Room(id: 2, name: 'Living Room', ceilingHeight: 10, length: 12, width: 12, doorCount: 1, windowCount: 2, accentWallCount: 1, hasChairRail: true));
    rooms.add(Room(id: 3, name: 'Bathroom', ceilingHeight: 8, length: 10, width: 9, doorCount: 1, windowCount: 3, accentWallCount: 0));
    rooms.add(Room(id: 4, name: 'Living Room', ceilingHeight: 10, length: 12, width: 12, doorCount: 1, windowCount: 2, accentWallCount: 1, hasChairRail: true));
    rooms.add(Room(id: 5, name: 'Garage', ceilingHeight: 10, length: 12, width: 12, doorCount: 1, windowCount: 2, accentWallCount: 1, hasChairRail: true));
    projectNotes.add(ProjectNote(description: 'Bright Colors!', hasCost: true));
    projectNotes.add(ProjectNote(description: 'New drywall', hasCost: true));
    projectNotes.add(ProjectNote(description: 'No carpets', hasCost: false));
    projectNotes.add(ProjectNote(description: 'New drywall', hasCost: true));
    projectNotes.add(ProjectNote(description: 'No carpets', hasCost: false));
    projectNotes.add(ProjectNote(description: 'Many items on walls', hasCost: true));
    roomNotes.add(RoomNote(id: 0, description: "Vaulted Ceiling", hasCost: true));
    roomNotes.add(RoomNote(id: 1, description: "Dark Colors", hasCost: true));
    roomNotes.add(RoomNote(id: 2, description: "Nail Holes", hasCost: true));
    roomNotes.add(RoomNote(id: 3, description: "Floor-to-ceiling windows", hasCost: false));
    roomNotes.add(RoomNote(id: 4, description: "painted can lights", hasCost: true));
  }

  List<Project> getProjects() => projects;
  Project getProject(int projectId) => projects[projectId];
  List<Room> getRooms(int projectId){
    switch (projectId) {
      case 0:
        return rooms.sublist(0,3);
        break;
      case 1:
        return rooms.sublist(3,5);
        break;
      case 2:
        return rooms.sublist(5,6);
        break;
      default:
    }
    return rooms;
  }
  Room getRoom(int roomId) => rooms[roomId];
  List<ProjectNote> getProjectNotes(int projectId){
    switch (projectId) {
      case 0:
        return projectNotes.sublist(0,3);
        break;
      case 1:
        return projectNotes.sublist(3,5);
        break;
      case 0:
        return projectNotes.sublist(5,6);
        break;
      default:
    }
    return projectNotes;
  }
  ProjectNote getProjectNote(int noteIndex) => projectNotes[noteIndex];
  List<RoomNote> getRoomNotes(int roomId){
    if(roomId < 2){
      return roomNotes.sublist(0, 3);
    }
    else{
      return roomNotes.sublist(3, 5);
    }
  }
  RoomNote getRoomNote(int noteIdx) => roomNotes[noteIdx];
}