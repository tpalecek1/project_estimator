import 'package:flutter/material.dart';
import 'package:project_estimator/models/fake_data.dart';
import 'package:project_estimator/models/project_note.dart';
import 'package:project_estimator/models/room.dart';
import 'package:project_estimator/models/room_note.dart';

class ProjectNotes extends StatefulWidget {

  static const routeName = 'project_notes';

  @override
  _ProjectNotesState createState() => _ProjectNotesState();
}

class _ProjectNotesState extends State<ProjectNotes> {

  //fake data alternative option, not use this one now, will delete this data after backend integration. Just for reference
  List<Entry> data = <Entry>[
    Entry('title', 'General Notes', false,
      <Entry>[
        Entry('projectNote', 'General Note 1 long long long long long long long long long long long long long long long long note', false),
        Entry('projectNote', 'General Note 2', true),
        Entry('projectNote', 'General Note 3', false),
      ],
    ),
    Entry('title', 'Room Notes', false,
      <Entry>[
        Entry('room', 'Living Room', false,
          <Entry>[
            Entry('roomNote', 'Room #1 Note 1', true),
            Entry('roomNote', 'Room #1 Note 2', false),
          ],
        ),
        Entry('room', 'bathroom', false,
          <Entry>[
            Entry('roomNote', 'Room #2 Note 1',false),
            Entry('roomNote', 'Room #2 Note 2',true),
          ],
        ),
      ],
    ),
  ];

  //get the data from the fake_data model and transform the data into the form that can be feeded into ExpansionTile
  List<Entry> getDate({String projectId}) { //get faked data from project id     
    
    FakeData fakeData = FakeData();
    List<Entry> whole = List<Entry>();

    //get projectNote data
    List<ProjectNote> projectNotesSource = fakeData.getProjectNotes(projectId);
    List<Entry> projectNoteList = List<Entry>();
    for(int i=0; i<projectNotesSource.length; i++) {
      Entry projectNote = Entry('projectNote', projectNotesSource[i].description,  projectNotesSource[i].hasCost);
      projectNoteList.add(projectNote);
    }
    Entry projectNoteLayoutBox = Entry('title', 'General Notes', false);
    projectNoteLayoutBox.children = projectNoteList;

    //get roomNote data
    List<Room> rooms = fakeData.getRooms(projectId);
    List<Entry> roomList = List<Entry>();
    for(int i=0; i<rooms.length; i++) {
      List<RoomNote> roomNotesSource = fakeData.getRoomNotes(rooms[i].id);
      List<Entry> roomNoteList = List<Entry>();
      for(int i=0; i<roomNotesSource.length; i++) {
        Entry roomNote = Entry('projectNote', roomNotesSource[i].description,  roomNotesSource[i].hasCost);
        roomNoteList.add(roomNote);
      }      
      Entry room = Entry('room', rooms[i].name, false);
      room.children = roomNoteList;
      roomList.add(room);
    }
    Entry roomNoteLayoutBox = Entry('title', 'Room Notes', false);
    roomNoteLayoutBox.children = roomList;

    whole.add(projectNoteLayoutBox);
    whole.add(roomNoteLayoutBox);

    return whole;
  }
  @override
  void initState() {
    super.initState();
    data = getDate(projectId: '0'); //get the faked data from project id '0'
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
          ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return EntryItem(data[index], index, delete);
            }
          ),
        ],
      )
    );
  }

  //the delete function
  void delete(int index, int roomIndex, int noteIndex) {
    setState(() {
      if(index == 0) { //index = 0 means "General Note" area
        data[index].children.removeAt(noteIndex);
      } else { //index = 1 means "Room Note" area
        data[index].children[roomIndex].children.removeAt(noteIndex);
        // if(data[index].children[roomIndex].children.isEmpty) {
        //   data[index].children.removeAt(roomIndex);
        // }
      }
    });
  }
}

// One entry in the multilevel list displayed by this app. (fake data unit)
class Entry {
  Entry(this.category, this.content, this.hasCost, [this.children = const <Entry>[]]); //optional parameter, if no children parameter, the default is an empty list
  String category; //title, room, projectNote, roomNote
  String content;
  List<Entry> children;
  bool hasCost;
  // final List<Map<String,dynamic>> estimateItem;
  int roomIndex = -99; //for tracking room index
  int noteIndex = -99; //for tracking each note item
}

// Displays one Entry. If the entry has children then it's displayed with an ExpansionTile.
class EntryItem extends StatelessWidget {
  EntryItem(this.entry, this.index, this.delete);
  final Entry entry;
  Function(int, int, int) delete;

  //there four kinds of indexes are used to track each note in the data
  int index; //0: in project notes area; 1: in room notes area
  int roomIndex = -2; //for tracking room index (which room the note locates), use 2 because first one is project title, sencond one is room title
  int roomIndexKeep = -99; //for helping restarting noteIndex for each room
  int noteIndex = -1; //for tracking each note item (index for each note in a room)

  @override
  Widget build(BuildContext context) {
    roomIndex = -2;
    noteIndex = -1;
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.brown, width: 3),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.fromLTRB(8, 4, 8, 4), 
      child: _buildTiles(entry) 
    );
  }

  Widget _buildTiles(Entry root) {

    //assign index to each entry, so later each item can be tracked
    if (root.children.isEmpty)
    {
      if(index == 0) { //index: 0 means "General Note" area, index:1 means "Room Note" area
        noteIndex++;
        root.noteIndex = noteIndex;
      } else {
        if(roomIndex != roomIndexKeep) { //if these two type of indexes are not the same, restart the count of noteIndex
          noteIndex = -1;
          roomIndexKeep = roomIndex;
        }
        noteIndex++;
        root.noteIndex = noteIndex;
        root.roomIndex = roomIndex;  
      }

      //Assign layout to each entry object
      if(root.category == "title") 
        return ListTile(title: Text(root.content), trailing:Text('empty', style: TextStyle(color: Colors.red)));
      else if(root.category == "room") {
        roomIndex++;
        return ListTile(title: Text(root.content), trailing:Text('empty', style: TextStyle(color: Colors.red)));
      } else if(root.hasCost) {
        return ListTile(title: RichText(
          text: TextSpan(children: [
            TextSpan(text:'${root.content}  ', style: TextStyle(fontSize: 16,color: Colors.black)),
            TextSpan(text:'has cost', style: TextStyle(color: Colors.red)),
          ])), 
          trailing: RaisedButton(onPressed: () {
          // print('$index, ${root.roomIndex}, ${root.noteIndex}');
            delete(index, root.roomIndex, root.noteIndex);
          }, child: Text('delete')
        ));
      }
      else
        return ListTile(title: Text(root.content), trailing: RaisedButton(onPressed: () {
          // print('$index, ${root.roomIndex}, ${root.noteIndex}');
          delete(index, root.roomIndex, root.noteIndex);
        }, child: Text('delete')));      
    }
    roomIndex++;  //for tracking room index
    return ExpansionTile(
      initiallyExpanded: root.category == 'room'|| root.content == 'Room Notes'? true: false, //expand all Room notes initailly
      key: PageStorageKey<Entry>(root),
      title: Text(root.content),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }
}