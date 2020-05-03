import 'package:flutter/material.dart';
import 'package:project_estimator/screens/room_photo_gallery.dart';
import 'package:project_estimator/widgets/custom_button_1.dart';
import '../models/room.dart';
import '../models/room_note.dart';
import '../models/fake_data.dart';
import '../widgets/checkbox_form_field.dart';
import '../widgets/new_note_dialog.dart';

class EditRoom extends StatefulWidget {
  EditRoom({Key key, this.room}) : super(key: key);
  final Room room;
  static const routeName = 'edit_room';

  @override 
  _EditRoomState createState() => _EditRoomState();
}



class _EditRoomState extends State<EditRoom> {
  final formKey = GlobalKey<FormState>();
  Room room;
  List<RoomNote> notes = [];
  List<String> photos = []; //Photo urls

  @override
  void initState() { 
    super.initState();
    //todo - Get room data from database and store in room
    getData();
    //If room does not exist, create a new one
  }

  void getData() async {
    await Future.delayed(const Duration(seconds: 1)); //Simulating delay from getting data
    //If project does not exist in database, create new project
    getFakeData();
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Edit Room')),
      body: waitData(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //todo - add room to database
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      )
    );
  }

  Widget waitData(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if(room == null){
      return Center(
        child: CircularProgressIndicator()
      );
    }
    else return Form(
      key: formKey,
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
                        initialValue: room.name,
                        width: (screenWidth / 2) - 10,
                        //todo
                        validator: (){},
                        //todo
                        onSaved: (){},
                      ),
                      textField(context,
                        labelText: "Ceiling Height",
                        initialValue: room.ceilingHeight.toString(),
                        width: (screenWidth / 2) - 10,
                        //todo
                        validator: (){},
                        //todo
                        onSaved: (){},
                      ),
                      Row(
                        children: [
                          textField(context,
                            labelText: "Length",
                            initialValue: room.length.toString(),
                            width: screenWidth / 4 - 10,
                            //todo
                            validator: (){},
                            //todo
                            onSaved: (){},
                          ),
                          textField(context,
                            labelText: "Width",
                            initialValue: room.width.toString(),
                            width: screenWidth / 4 - 10,
                            //todo
                            validator: (){},
                            //todo
                            onSaved: (){},
                          ),
                        ]
                      ),
                      CheckboxFormField(
                        title: Text('Baseboard'),
                        initialValue: room.hasBaseboard,
                        onSaved: (value){
                          //todo
                        },
                      ),
                      CheckboxFormField(
                        title: Text('Chair Rail'),
                        initialValue: room.hasChairRail,
                        onSaved: (value){
                          //todo
                        },
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
                        initialValue: room.doorCount.toString(),
                        labelText: "Doors",
                        width: screenWidth / 2 - 10,
                        onSaved: (value){},
                        validator: (value){}
                      ),
                      textField(
                        context,
                        initialValue: room.windowCount.toString(),
                        labelText: "Windows",
                        width: screenWidth / 2 - 10,
                        onSaved: (value){},
                        validator: (value){}
                      ),
                      textField(
                        context,
                        initialValue: room.accentWallCount.toString(),
                        labelText: "Accent Walls",
                        width: screenWidth / 2 - 10,
                        onSaved: (value){},
                        validator: (value){}
                      ),
                      CheckboxFormField(
                        initialValue: room.hasCrown,
                        title: Text('Crown Molding', textAlign: TextAlign.left,),
                        onSaved: (value){
                          //todo
                        },
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
                              //todo - add note to database
                              onSubmit: (hasCost, note){Navigator.of(context).pop(); print(hasCost); print(note);},
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
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index){
                return Container(
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(notes[index].description),
                    trailing: FlatButton(
                      child: Icon(Icons.delete),
                      onPressed: (){}, //todo - delete note from list and database
                    ),
                  )
                );
              }),
            )
          ],
        )
    );
  }
  void getFakeData() {
    room = widget.room;
    if(room.id != null){
      notes = FakeData().getRoomNotes(room.id);
    }
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