import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_estimator/screens/edit_room.dart';
import 'package:project_estimator/screens/project_notes.dart';
import 'package:project_estimator/widgets/custom_button_1.dart';
import 'package:project_estimator/widgets/new_note_dialog.dart';
import '../models/project.dart';
import '../models/room.dart';
import '../widgets/new_note_dialog.dart';
import 'package:project_estimator/services/database.dart';

class EditProject extends StatefulWidget{
  EditProject({Key key, this.userId, this.project}) : super(key: key);
  static const routeName = 'edit_project';
  final String userId;
  final Project project;

  @override
  _EditProjectState createState() => _EditProjectState();
}



class _EditProjectState extends State<EditProject> {
  final formKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  bool _hasInvalidInput = false;
  bool _roomsAreModified = false;

  Project _project;
  List<Room> _rooms;
  StreamSubscription<List<Room>> _roomStreamSubscription;

  @override 
  void initState() { 
    super.initState();
    
    _project = widget.project;
    if (_project.id != null) {
      _listenForRooms();
    }
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false, //Changes keyboard to an overlay instead of pushing the screen up
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _project.id == null ? Text('New Project') : Text('Edit Project'),
        actions: <Widget>[
          Visibility(
            visible: _roomsAreModified ? false : true,
            child: FlatButton(
              child: Text('Cancel', style: TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      body: _body(),
      floatingActionButton: Visibility(
        visible: _isProcessing ? false : true,
        child: FloatingActionButton(
          onPressed: () async {
            if(formKey.currentState.validate()){
              formKey.currentState.save();

              if (_project.id == null) {
                setState(() { _isProcessing = true; _hasInvalidInput = false; });
                String projectId = await Database().createProject(widget.userId, _project);
                _project = await Database().readProject(projectId);
                _listenForRooms();
                setState(() { _isProcessing = false; });
              }
              else {
                  Database().updateProject(_project);
                  Navigator.of(context).pop();
              }

            }
            else {
              setState(() { _hasInvalidInput = true; });
            }
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }

  Widget _body() {
    if (_project.id == null) {
      return Center(child: _newProjectName());
    }
    else if (_isProcessing) {
      return Center(child: CircularProgressIndicator());
    }
    else {
      return _projectInfo();
    }
  }

  Widget _projectName() {
    return TextFormField(
      autovalidate: _hasInvalidInput ? true : false,
      initialValue: _project.name,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Project Name',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      onSaved: (name) => _project.name = name.trim(),
      validator: (name) => name.trim().length == 0 ? 'Project name can\'t be empty' : null,
    );
  }

  Widget _newProjectName() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: _projectName(),
      ),
    );
  }

  Widget _projectInfo() {
    return Form(
      key: formKey,
      child: Column(
          children: [
            Flexible(
              flex: 7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Project Description',
                    style: Theme.of(context).textTheme.display1,
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(5),
                    child: _projectName(),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      initialValue: _project.clientName,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Customer Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onSaved: (clientName) => _project.clientName = clientName.trim(),
                      validator: (clientName) => null,
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      autovalidate: _hasInvalidInput ? true : false,
                      initialValue: _project.clientAddress,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onSaved: (address) => _project.clientAddress = address.trim(),
                      validator: (address) => null,
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      autovalidate: _hasInvalidInput ? true : false,
                      initialValue: _project.description,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onSaved: (description) => _project.description = description.trim(),
                      validator: (description) => null,
                    ),
                  ),
                ],)
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton1(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ProjectNotes.routeName);
                      },
                      child: Text('View Project Notes'),
                    ),
                  ),
                  Expanded(
                    child: CustomButton1(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context){
                            return NewNoteDialog(
                              title: "New Project Note", 
                              hint: "Enter project note",
                              onCancel: (){Navigator.of(context).pop();},
                              //todo - add note to database
                              onSubmit: (hasCost, note){Navigator.of(context).pop(); print(hasCost); print(note);},
                            );
                          }
                        );
                      },
                      child: Text('Add Project Note'),
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Center(
                child: CustomButton1(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditRoom(projectId: _project.id, room: Room())))
                    .then((roomIsModified) {
                      setState(() { _roomsAreModified = roomIsModified; });
                    });
                  },
                  child: Text('Add Room'),
                )
              )
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Text('Rooms List', 
                    style: Theme.of(context).textTheme.display1
                  ), 
                )
              )
            ),
            Flexible(
              flex: 4,
              child: _rooms == null ?
              Center(child: CircularProgressIndicator()) :
              ListView.builder(
                itemCount: _rooms.length,
                itemBuilder: (context, index){
                return Container(
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(_rooms[index].name),
                    trailing: Icon(Icons.edit),
                    onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditRoom(room: _rooms[index])))
                        .then((roomIsModified) {
                          setState(() { _roomsAreModified = roomIsModified; });
                        })
                    },
                  )
                );
              }),
            ),
          ]
        )
    );
  }
  
  void _listenForRooms() {
    _roomStreamSubscription = Database().readRoomsRealTime(_project.id).listen((rooms) {
      rooms.sort((a, b) => (a.name).compareTo(b.name));
      setState(() { _rooms = rooms; });
    });
  }

  @override
  void dispose() {
    _roomStreamSubscription?.cancel();
    super.dispose();
  }
}