import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_estimator/screens/edit_room.dart';
import 'package:project_estimator/screens/project_notes.dart';
import 'package:project_estimator/screens/project_list.dart';
import 'package:project_estimator/widgets/custom_button_1.dart';
import 'package:project_estimator/widgets/new_note_dialog.dart';
import '../models/project.dart';
import '../models/project_note.dart';
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
  
  String _dropdownValue;
  bool _isProcessing = false;
  bool _hasInvalidInput = false;
  bool _projectIsModified = false;  // true when new (or edited) project note(s), room(s), room note(s) and/or room photo(s) (when project related entities/sub-collections are modified)

  Project _projectInitialState;     // to help determine if project entity/document (not its related entities/sub-collections) needs to be updated
  Project _project;
  List<Room> _rooms;
  StreamSubscription<List<Room>> _roomStreamSubscription;

  @override 
  void initState() { 
    super.initState();
    
    _project = widget.project;
    if (_project.id != null) {
      _projectInitialState = Project.fromProject(_project);
      _dropdownValue = _project.status;
      _listenForRooms();
    }
  }

  @override 
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async => _projectIsModified ? false : true,   // disable Android system "back" button (when project is modified)
      child: Scaffold(
        resizeToAvoidBottomInset: false, //Changes keyboard to an overlay instead of pushing the screen up
        appBar: AppBar(
          automaticallyImplyLeading: false,                       // remove Flutter automatic "back" button from AppBar
          title: _project.id == null ? Text('New Project') : Text('Edit Project'),
          actions: <Widget>[
            Visibility(
              visible: _projectIsModified ? false : true,         // show cancel button when project is not modified
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
                  _projectInitialState = Project.fromProject(_project);
                  _listenForRooms();
                  setState(() { _isProcessing = false; });
                }
                else {
                  if (_project != _projectInitialState) {
                    Database().updateProject(_project);
                  }
                  Navigator.of(context).pop(setState((){}));
                }

              }
              else {
                setState(() { _hasInvalidInput = true; });
              }
            },
            child: Icon(Icons.check),
          ),
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
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Project Description',
                        style: Theme.of(context).textTheme.display1,
                        textAlign: TextAlign.left,
                      ),
                      Flexible(
                        child: Container(
                            height: 50,
                            padding: EdgeInsets.all(5),
                            child: RaisedButton(
                              color: Color.fromARGB(25, 255, 0, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(color: Colors.red[400], width: 1.1)
                              ),
                              child: Text('Delete'),
                              onPressed: () => {
                                showDialog(context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      title: Text("Are you sure you want to permanently delete this project?"),
                                      content: Text("Note: this cannot be undone"),
                                      actions: [
                                        FlatButton(
                                          onPressed: (){
                                            print(widget.userId);
                                            Navigator.of(context).pop();
                                          },
                                          child: Icon(Icons.cancel),
                                        ),
                                        FlatButton(
                                          onPressed: (){
                                            Database().deleteProject(_project.id);
                                            //setState((){});
                                            Navigator.of(context).pop(Navigator.of(context).pop(Navigator.of(context).pop()));
                                            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectList(userId: widget.userId)));
                                          },
                                          child: Icon(Icons.check),
                                        )
                                      ],
                                    );
                                  }
                                )
                              },
                            ),
                          ),
                      ),
                    ]
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: _projectName(),
                  ),
                  Container(
                    height: 46,
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
                    height: 46,
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
                    height: 46,
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
                  Flexible(
                    child: Container(
                      height: 46,
                      padding: EdgeInsets.all(5),
                      child: DropdownButtonFormField(
                        items: <String>['not bid', 'bid', 'not awarded', 'awarded', 'started', 'complete'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue){
                              _project.status = newValue;
                              setState(() {
                                _dropdownValue = newValue;
                              });
                            },
                          value: _dropdownValue,
                          decoration: InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          ),
                      ),
                    ),
                  ),
                ],),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton1(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectNotes(projectId: _project.id)))
                        .whenComplete(() {
                          setState(() { _projectIsModified = true; });    // even though project note(s) may not have been deleted, if user did delete one/some, less confusing if can't cancel on this screen
                        });
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
                              onSubmit: (hasCost, note) {
                                Database().createProjectNote(_project.id, ProjectNote(hasCost: hasCost, description: note));
                                setState(() { _projectIsModified = true; });
                                Navigator.of(context).pop();
                              },
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
                      setState(() { _projectIsModified = roomIsModified; });
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
                padding: EdgeInsets.only(left: 5),
                child: Align(
                  alignment: Alignment.topLeft,
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
                  margin: EdgeInsets.fromLTRB(5, 2, MediaQuery.of(context).size.width*.25, 2),
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(_rooms[index].name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 50,
                          child: FlatButton(
                            child: Icon(Icons.edit),
                            onPressed: () => {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditRoom(room: _rooms[index])))
                              .then((roomIsModified) {
                                setState(() { _projectIsModified = roomIsModified; });
                              })
                          },
                          ),
                        ),
                        Container(
                          width: 50,
                          child: FlatButton(
                            child: Icon(Icons.delete),
                            onPressed: () => {
                              showDialog(context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text("Are you sure you want to permanently delete this room?"),
                                    content: Text("Note: this cannot be undone"),
                                    actions: [
                                      FlatButton(
                                        onPressed: (){
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(Icons.cancel),
                                      ),
                                      FlatButton(
                                        onPressed: () {
                                          Database().deleteRoom(_rooms[index].id);
                                          _rooms.removeAt(index);
                                          setState((){ _projectIsModified = true; });
                                          Navigator.of(context).pop();
                                        },
                                        child: Icon(Icons.check),
                                      )
                                    ],
                                  );
                                }
                              )
                            },
                          ),
                        ),
                      ]
                    ),
                    // onTap: () => {
                    //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditRoom(room: _rooms[index])))
                    //     .then((roomIsModified) {
                    //       setState(() { _projectIsModified = roomIsModified; });
                    //     })
                    // },
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