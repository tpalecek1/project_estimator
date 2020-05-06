import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_estimator/screens/room_photo_gallery.dart';
import 'package:project_estimator/widgets/custom_button_1.dart';
import '../models/room.dart';
import '../models/room_note.dart';
import '../widgets/checkbox_form_field.dart';
import '../widgets/new_note_dialog.dart';
import 'package:project_estimator/services/database.dart';

class EditRoom extends StatefulWidget {
  EditRoom({Key key, this.projectId, this.room}) : super(key: key);
  static const routeName = 'edit_room';
  final String projectId;
  final Room room;


  @override 
  _EditRoomState createState() => _EditRoomState();
}



class _EditRoomState extends State<EditRoom> {
  final formKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  bool _hasInvalidInput = false;

  Room _room;
  List<RoomNote> _notes;
  StreamSubscription<List<RoomNote>> _roomNoteStreamSubscription;

  @override
  void initState() { 
    super.initState();

    _room = widget.room;
    if (_room.id != null) {
      _listenForRoomNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: _room.id == null ? Text('New Room') : Text('Edit Room'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (_room.id == null) {
                Navigator.of(context).pop();
              }
              else {
                if(formKey.currentState.validate()){
                  formKey.currentState.save();
                  Database().updateRoom(_room);
                  Navigator.of(context).pop();
                }
                else {
                  setState(() { _hasInvalidInput = true; });
                }
              }
            }
        ),
      ),
      body: _body(context),
      floatingActionButton: Visibility(
        visible: _isProcessing || _room.id != null ? false : true,
        child: FloatingActionButton(
          onPressed: () async {
            if(formKey.currentState.validate()){
              formKey.currentState.save();

              setState(() { _isProcessing = true; _hasInvalidInput = false; });
              String roomId = await Database().createRoom(widget.projectId, _room);
              _room = await Database().readRoom(roomId);
              _listenForRoomNotes();
              setState(() { _isProcessing = false; });
            }
            else {
              setState(() { _hasInvalidInput = true; });
            }
          },
          child: Icon(Icons.check),
      ))
    );
  }

  Widget _body(context) {
    if (_room.id == null) {
      return Center(child: _newRoomName());
    }
    else if (_isProcessing) {
      return Center(child: CircularProgressIndicator());
    }
    else {
      return _roomInfo(context);
    }
  }

  Widget _newRoomName() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: formKey,
        child: TextFormField(
          autovalidate: _hasInvalidInput ? true : false,
          initialValue: _room.name,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: 'Room Name',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          onSaved: (name) => _room.name = name.trim(),
          validator: (name) => name.trim().length == 0 ? 'Room name can\'t be empty' : null,
        ),
      ),
    );
  }

  Widget _roomInfo(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Form(
      key: formKey,
      autovalidate: _hasInvalidInput ? true : false,
      child: Column(
          children: [
          Text(
            'Measurements',
            style: Theme.of(context).textTheme.display1,
            textAlign: TextAlign.left,
          ),
          Flexible(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textField(context,
                        labelText: "Name",
                        initialValue: _room.name,
                        width: (screenWidth / 2) - 10,
                        validator: (name) => name.trim().length == 0 ? 'Room name can\'t be empty' : null,
                        onSaved: (name) => _room.name = name.trim(),
                      ),
                      textField(context,
                        labelText: "Ceiling Height",
                        initialValue: _room.ceilingHeight.toString(),
                        width: (screenWidth / 2) - 10,
                        validator: (ceilingHeight) => double.tryParse(ceilingHeight) == null ? 'Invalid ceiling height' : null,
                        onSaved: (ceilingHeight) => _room.ceilingHeight = double.parse(ceilingHeight),
                      ),
                      Row(
                        children: [
                          textField(context,
                            labelText: "Length",
                            initialValue: _room.length.toString(),
                            width: screenWidth / 4 - 10,
                            validator: (length) => double.tryParse(length) == null ? 'Invalid length' : null,
                            onSaved: (length) => _room.length = double.parse(length),
                          ),
                          textField(context,
                            labelText: "Width",
                            initialValue: _room.width.toString(),
                            width: screenWidth / 4 - 10,
                            validator: (width) => double.tryParse(width) == null ? 'Invalid width' : null,
                            onSaved: (width) => _room.width = double.parse(width),
                          ),
                        ]
                      ),
                      CheckboxFormField(
                        title: Text('Baseboard'),
                        initialValue: _room.hasBaseboard,
                        onSaved: (value) => _room.hasBaseboard = value,
                      ),
                      CheckboxFormField(
                        title: Text('Chair Rail'),
                        initialValue: _room.hasChairRail,
                        onSaved: (value) => _room.hasChairRail = value,
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 40),),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      textField(
                        context,
                        initialValue: _room.doorCount.toString(),
                        labelText: "Doors",
                        width: screenWidth / 2 - 10,
                        onSaved: (doorCount) => _room.doorCount = int.parse(doorCount),
                        validator: (doorCount) => int.tryParse(doorCount) == null ? 'Invalid number of doors' : null,
                      ),
                      textField(
                        context,
                        initialValue: _room.windowCount.toString(),
                        labelText: "Windows",
                        width: screenWidth / 2 - 10,
                        onSaved: (windowCount) => _room.windowCount = int.parse(windowCount),
                        validator: (windowCount) => int.tryParse(windowCount) == null ? 'Invalid number of windows' : null,
                      ),
                      textField(
                        context,
                        initialValue: _room.accentWallCount.toString(),
                        labelText: "Accent Walls",
                        width: screenWidth / 2 - 10,
                        onSaved: (accentWallCount) => _room.accentWallCount = int.parse(accentWallCount),
                        validator: (accentWallCount) => int.tryParse(accentWallCount) == null ? 'Invalid number of accent walls' : null,
                      ),
                      CheckboxFormField(
                        initialValue: _room.hasCrown,
                        title: Text('Crown Molding', textAlign: TextAlign.left,),
                        onSaved: (value) => _room.hasCrown = value,
                      ),
                    ],
                  ),
                ),
              ]
            )
          ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton1(
                      onPressed: () {
                        //todo: Add Photo
                      },
                      child: Text('Add Photo')
                    ),
                  ),
                  Expanded(
                    child: CustomButton1(
                      onPressed: () {
                        Navigator.of(context).pushNamed(RoomPhotoGallery.routeName);
                      },
                      child: Text('View Photos')
                    ),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Expanded(child: Container(child: Align(child: Text('Room Notes', style: Theme.of(context).textTheme.display1), alignment: Alignment.centerLeft))),
                  CustomButton1(
                    onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context){
                            return NewNoteDialog(
                              title: "New Room Note", 
                              hint: "Enter room note",
                              onCancel: (){Navigator.of(context).pop();},
                              onSubmit: (hasCost, note) {
                                Database().createRoomNote(_room.id, RoomNote(hasCost: hasCost, description: note));
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        );
                      },
                    child: Text('Add Note'),
                  )
                ]
              )
            ),
            Flexible(
              flex: 4,
              child: _notes == null ?
              Center(child: CircularProgressIndicator()) :
              ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index){
                return Container(
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(_notes[index].description),
                    trailing: FlatButton(
                      child: Icon(Icons.delete),
                      onPressed: (){
                        Database().deleteRoomNote(_notes[index].id);
                      },
                    ),
                  )
                );
              }),
            )
          ],
        )
    );
  }

  void _listenForRoomNotes() {
    _roomNoteStreamSubscription = Database().readRoomNotesRealTime(_room.id).listen((notes) {
      notes.sort((a, b) => (a.description).compareTo(b.description));
      setState(() { _notes = notes; });
    });
  }

  @override
  void dispose() {
    _roomNoteStreamSubscription?.cancel();
    super.dispose();
  }
}

Widget textField(BuildContext context,{String labelText, String initialValue, double width, Function onSaved, Function validator}){
  return Container(
    height: 40,
    width: width,
    child: Padding(
      padding: EdgeInsets.all(2),
      child: TextFormField(
        initialValue: initialValue,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        ),
        onSaved: (value){
          onSaved(value);
        },
        validator: (value){
          validator(value);
        }
      ),
    )
  );
}

Widget numField(BuildContext context,{String labelText, double, initialValue, double width, Function onSaved, Function validator}){
  return Container(
    height: 40,
    width: width,
    child: Padding(
      padding: EdgeInsets.all(2),
      child: TextFormField(
        initialValue: initialValue,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        ),
        onSaved: (value){
          onSaved(value);
        },
        validator: (value){
          validator(value);
        }
      ),
    )
  );
}