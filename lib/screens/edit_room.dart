import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_estimator/screens/room_photo_gallery.dart';
import 'package:project_estimator/services/permission_manager.dart';
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



class _EditRoomState extends State<EditRoom> with TickerProviderStateMixin {
  final formKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  bool _hasInvalidInput = false;
  bool _roomIsModified = false;     // true when new (or edited) room, room note(s) and/or room photo(s)

  Room _roomInitialState;           // to help determine if room entity/document (not its related entities/sub-collections) needs to be updated
  Room _room;
  List<RoomNote> _notes;
  StreamSubscription<List<RoomNote>> _roomNoteStreamSubscription;

  File image;

  //animation variables
  AnimationController _animationController;
  Animation _sizeAnimation;

  @override
  void initState() { 
    super.initState();

    //initialize animation variables
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _sizeAnimation = Tween(begin: 0.0, end: 1.0).animate(_animationController);

    _room = widget.room;
    if (_room.id != null) {
      _roomInitialState = Room.fromRoom(_room);
      _listenForRoomNotes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {                                       // disable Android system "back" button (when room is modified)
        if (!_roomIsModified) {
          Navigator.of(context).pop(_roomIsModified);
        }
        return false;
      },
      child: Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,                     // remove Flutter automatic "back" button from AppBar
            title: _room.id == null ? Text('New Room') : Text('Edit Room'),
            actions: <Widget>[
              Visibility(
                visible: _roomIsModified ? false : true,          // show cancel button when room is not modified
                child: FlatButton(
                  child: Text('Cancel', style: TextStyle(fontSize: 17.0, color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop(_roomIsModified);
                  },
                ),
              ),
            ],
          ),
          body: _body(context),
          floatingActionButton: Visibility(
              visible: _isProcessing ? false : true,
              child: FloatingActionButton(
                onPressed: () async {
                  if(formKey.currentState.validate()){
                    formKey.currentState.save();

                    if (_room.id == null) {
                      setState(() { _isProcessing = true; _hasInvalidInput = false; });
                      String roomId = await Database().createRoom(widget.projectId, _room);
                      _room = await Database().readRoom(roomId);
                      _roomInitialState = Room.fromRoom(_room);
                      _listenForRoomNotes();
                      setState(() { _isProcessing = false; _roomIsModified = true; });
                    }
                    else {
                      if (_room != _roomInitialState) {
                        Database().updateRoom(_room);
                      }
                      _roomIsModified = true;   // even though room entity/document may not have changed, user pressed fab checkmark, so less confusing if can't cancel on EditProject screen
                      Navigator.of(context).pop(_roomIsModified);
                    }

                  }
                  else {
                    setState(() { _hasInvalidInput = true; });
                  }
                },
                child: Icon(Icons.check),
              ))
      ),
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
    double bannerHeight = 60.0;
    return Stack(
      children:[
        SingleChildScrollView(
          child: Form(
            key: formKey,
            autovalidate: _hasInvalidInput ? true : false,
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context,index){
                    return Container(
                      width: screenWidth,
                      height:60*_sizeAnimation.value
                    );
                  }
                ),
                Text(
                  'Measurements',
                  style: Theme.of(context).textTheme.display1,
                  textAlign: TextAlign.left,
                ),
                Container(
                  width: screenWidth,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
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
                        Expanded(
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
                    // ]
                  // ),
                ),
                Container(
                  width: screenWidth,
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomButton1(
                          onPressed: () {
                            //Add Photo
                            showDialog(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                  title: Container(child: const Text('Select a way to add your photo'), alignment: Alignment.center),
                                  contentPadding:const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 5.0),
                                  children: <Widget>[
                                    Divider(height: 1),
                                    SimpleDialogOption(
                                      child: Container(height:30, child: const Text('Camera'), alignment: Alignment.center),
                                      onPressed: () async { 
                                        Navigator.of(context).pop(); 
                                        image = null;
                                        image = await ImagePicker.pickImage(source: ImageSource.camera);
                                        if(image != null) {
                                          //start animation: take the banner out
                                          _animationController.forward();
                                          //todo: uploading the photo
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    Divider(height: 1),
                                    SimpleDialogOption(
                                      child: Container(height:30, child: const Text('Photo Gallery'), alignment: Alignment.center),
                                      onPressed: () async { 
                                        if(await PermissionManager.checkAndRequestStoragePermissions()) { 
                                          Navigator.of(context).pop(); 
                                          image = null;
                                          image = await ImagePicker.pickImage(source: ImageSource.gallery);
                                          if(image != null) {
                                            //start animation: take the banner out
                                            _animationController.forward();
                                            //todo: uploading the photo
                                            setState(() {});
                                          }
                                        }                                         
                                      },
                                    ),
                                    Divider(height: 1, color: Colors.blue),
                                    SimpleDialogOption(
                                      child: Container(height:30, child: const Text('Cancel', style: TextStyle(color: Colors.blue)), alignment: Alignment.center),
                                      onPressed: () { 
                                        Navigator.of(context).pop(); 
                                      },
                                    )                                   
                                  ],
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
                                );
                              }
                            );
                          },
                          child: Text('Add Photo')
                        ),
                      ),
                      Expanded(
                        child: CustomButton1(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoomPhotoGallery(roomId: _room.id)))
                            .then((roomIsModified) {
                              if (!_roomIsModified && roomIsModified) {
                                setState(() { _roomIsModified = roomIsModified; });
                              }
                            });
                          },
                          child: Text('View Photos')
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: screenWidth,
                  height: 65,
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
                                    setState(() { _roomIsModified = true; });
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
                _notes == null ?
                Center(child: CircularProgressIndicator()) :
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _notes.length,
                  itemBuilder: (context, index){
                  return Container(
                    margin: EdgeInsets.fromLTRB(5, 2, MediaQuery.of(context).size.width*.25, 2),
                    //margin: EdgeInsets.all(1),
                    decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(_notes[index].description),
                      trailing: Container(
                        width: 50,
                        child: FlatButton(
                          child: Icon(Icons.delete),
                          onPressed: (){
                            Database().deleteRoomNote(_notes[index].id);
                            setState(() { _roomIsModified = true; });
                          },
                        ),
                      ),
                    )
                  );
                }),
                // Container( //test use only
                //   width: 100,
                //   height: 100,
                //   child: image==null? Text("no image"): Image(image: FileImage(image)),
                // )
              ],
            )
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder:(context,index){ 
            return Positioned(
            top: -60 + _sizeAnimation.value * bannerHeight,
            // top: -20,
            left: 0,
            child: SizedBox(
              width: screenWidth,
              height: 60,
              child: Opacity(
                opacity: 0.90,
                child: MaterialBanner(
                  contentTextStyle: TextStyle(color: Colors.white, backgroundColor: Colors.indigo),
                  content: Text(
                    "Uploading Picture...",
                  ),
                  leading: Image(image: AssetImage("assets/images/loading.gif"), height: 30,),   
                  backgroundColor: Colors.indigo,
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancel", style: TextStyle(color: Colors.white)),
                      onPressed: _hideBanner,
                    ),
                  ],
                ),
              ),
            ),
          );
          }
        ),
      ]
    );
  }

  void _hideBanner() {
    //reverse the animation: hide the banner out of screen
    _animationController.reverse();
    // setState((){});
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
    _animationController.dispose();
    super.dispose();
  }

  Widget textField(BuildContext context,{String labelText, String initialValue, double width, Function onSaved, Function validator}){
    return Container(
      //height: 50,
      width: width,
      child: Padding(
        padding: EdgeInsets.all(2),
        child: TextFormField(
          autovalidate: _hasInvalidInput ? true : false,
          initialValue: initialValue,
          textAlign: TextAlign.left,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            errorStyle: TextStyle(
              fontSize: 10,
            ),
            labelText: labelText,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          ),
          onSaved: (value){
            onSaved(value);
          },
          validator: (value){
            return validator(value);
          }
        ),
      )
    );
  }
}
