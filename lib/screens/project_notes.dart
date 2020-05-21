import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_estimator/services/database.dart';
import 'package:project_estimator/models/project_note.dart';
import 'package:project_estimator/models/room.dart';
import 'package:project_estimator/models/room_note.dart';

class ProjectNotes extends StatefulWidget {
  ProjectNotes({ Key key, this.projectId }) : super(key: key);
  static const routeName = 'project_notes';
  final String projectId;

  @override
  _ProjectNotesState createState() => _ProjectNotesState();
}

class _ProjectNotesState extends State<ProjectNotes> {

  List<ProjectNote> _projectNotes;
  Map<String, RoomInfo> _roomNotes;   // { 'roomId': RoomInfo(name: 'room name', notes: List<RoomNote>) }

  StreamSubscription<List<ProjectNote>> _projectNoteStreamSubscription;
  List<StreamSubscription<List<RoomNote>>> _roomNoteStreamSubscriptions;

  @override
  void initState() {
    super.initState();

    _listenForProjectNotes();
    _listenForProjectRoomsNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Project Notes'),
        ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/note.png'), fit: BoxFit.fill))
            ),
            _projectNotes == null || _roomNotes == null ?
            Center(child: CircularProgressIndicator()) :
            ListView(
              padding: EdgeInsets.only(top: 16),
              children: <Widget>[
                Card(                                           // General notes
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.brown, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: _projectNotes.length == 0 ?
                    ListTile(title: Text('General Notes'), trailing:Text('empty', style: TextStyle(color: Colors.red))) :
                    ExpansionTile(
                      initiallyExpanded: false,
                      title: Text('General Notes'),
                      children: <Widget>[
                        ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _projectNotes.length,
                          itemBuilder: (context, index) {
                            if (_projectNotes[index].hasCost) {
                              return ListTile(
                                  title: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(text:'${_projectNotes[index].description}  ', style: TextStyle(fontSize: 16,color: Colors.black)),
                                        TextSpan(text:'has cost', style: TextStyle(color: Colors.red)),
                                      ])
                                  ),
                                  trailing: RaisedButton(
                                      onPressed: () { Database().deleteProjectNote(_projectNotes[index].id); },
                                      child: Text('delete')
                                  )
                              );
                            }
                            else {
                              return ListTile(
                                  title: Text(_projectNotes[index].description),
                                  trailing: RaisedButton(
                                      onPressed: () { Database().deleteProjectNote(_projectNotes[index].id); },
                                      child: Text('delete')
                                  )
                              );
                            }
                          },
                        ),
                      ],
                    ),
                ),
                Card(                                          // Room notes
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.brown, width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: _roomNotes.length == 0 ?
                    ListTile(title: Text('Room Notes'), trailing:Text('empty', style: TextStyle(color: Colors.red))) :
                    ExpansionTile(
                      initiallyExpanded: true,
                      title: Text('Room Notes'),
                      children: <Widget>[
                        ListView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _roomNotes.length,
                          itemBuilder: (context, roomIndex) {
                            String roomId = _roomNotes.keys.elementAt(roomIndex);
                            if (_roomNotes[roomId].notes.length == 0) {
                              return ListTile(
                                  title: Text(_roomNotes[roomId].name),
                                  trailing:Text('empty', style: TextStyle(color: Colors.red))
                              );
                            }
                            else {
                              return ExpansionTile(
                                initiallyExpanded: true,
                                title: Text(_roomNotes[roomId].name),
                                children: <Widget>[
                                  ListView.builder(
                                    physics: ScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _roomNotes[roomId].notes.length,
                                    itemBuilder: (context, noteIndex) {
                                      if (_roomNotes[roomId].notes[noteIndex].hasCost) {
                                        return ListTile(
                                            title: RichText(
                                                text: TextSpan(children: [
                                                  TextSpan(text:'${_roomNotes[roomId].notes[noteIndex].description}  ', style: TextStyle(fontSize: 16,color: Colors.black)),
                                                  TextSpan(text:'has cost', style: TextStyle(color: Colors.red)),
                                                ])
                                            ),
                                            trailing: RaisedButton(
                                                onPressed: () { Database().deleteRoomNote(_roomNotes[roomId].notes[noteIndex].id); },
                                                child: Text('delete')
                                            )
                                        );
                                      }
                                      else {
                                        return ListTile(
                                            title: Text(_roomNotes[roomId].notes[noteIndex].description),
                                            trailing: RaisedButton(
                                                onPressed: () { Database().deleteRoomNote(_roomNotes[roomId].notes[noteIndex].id); },
                                                child: Text('delete')
                                            )
                                        );
                                      }
                                    },
                                  )
                                ],
                              );
                            }
                          },
                        )
                      ],
                    ),
                )
              ],
            ),
          ],
        )
    );
  }

  void _listenForProjectNotes() {
    _projectNoteStreamSubscription = Database().readProjectNotesRealTime(widget.projectId).listen((notes) {
      notes.sort((a, b) => (a.description).compareTo(b.description));
      setState(() { _projectNotes = notes; });
    });
  }

  void _listenForProjectRoomsNotes() async {
    List<Room> rooms = await Database().readRooms(widget.projectId);
    rooms.sort((a, b) => (a.name).compareTo(b.name));

    _roomNotes = Map<String, RoomInfo>();
    _roomNoteStreamSubscriptions = List<StreamSubscription<List<RoomNote>>>();

    StreamSubscription<List<RoomNote>> roomNoteStreamSubscription;

    await Future.forEach(rooms, (room) async {
      _roomNotes[room.id] = RoomInfo(name: room.name, notes: List<RoomNote>());
      roomNoteStreamSubscription = Database().readRoomNotesRealTime(room.id).listen((notes) {
        notes.sort((a, b) => (a.description).compareTo(b.description));
        setState(() { _roomNotes[room.id].notes = notes; });
      });
      _roomNoteStreamSubscriptions.add(roomNoteStreamSubscription);
    });
  }

  @override
  void dispose() {
    _projectNoteStreamSubscription.cancel();
    _roomNoteStreamSubscriptions.forEach((roomNoteStreamSubscription) { roomNoteStreamSubscription.cancel(); });
    super.dispose();
  }
}

class RoomInfo {
  String name;
  List<RoomNote> notes;

  RoomInfo({ this.name, this.notes });
}
