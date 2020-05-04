import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_estimator/screens/edit_room.dart';
import 'package:project_estimator/screens/project_notes.dart';
import 'package:project_estimator/widgets/custom_button_1.dart';
import 'package:project_estimator/widgets/new_note_dialog.dart';
import '../models/project.dart';
import '../models/room.dart';
import '../widgets/new_note_dialog.dart';
import '../models/fake_data.dart';

class EditProject extends StatefulWidget{
  EditProject({Key key, this.project}) : super(key: key);
  static const routeName = 'edit_project';
  Project project;

  @override
  _EditProjectState createState() => _EditProjectState();
}



class _EditProjectState extends State<EditProject> {
  final formKey = GlobalKey<FormState>();
  Project project;
  List<Room> rooms = [];

  @override 
  void initState() { 
    super.initState();
    //todo - Get project and rooms(only name and ID needed for rooms) from database if exists, get project's rooms, fill rooms list
    getData();
  }

  void getData() async {
    await Future.delayed(const Duration(seconds: 1)); //Simulating delay from getting data
    //If project does not exist in database, create new project
    getFakeData();
    setState((){});
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false, //Changes keyboard to an overlay instead of pushing the screen up
      appBar: AppBar(title: Text('Edit Project')),
      body: waitData(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //todo - Validate and save form data
          if(formKey.currentState.validate()){
            formKey.currentState.save();
          }
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      )
    );
  }

  Widget waitData() {
    if(project == null){
      return Center(
        child: CircularProgressIndicator()
      );
    }
    else{
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
                    child: TextFormField(
                      initialValue: project.name,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Project Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onSaved: (value){
                        //todo
                        print("Customer Name: \n");
                      },
                      validator: (value){
                        //todo
                        print("Validating Customer Name\n");
                      }
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      initialValue: project.clientName,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Customer Name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onSaved: (value){
                        //todo
                        print("Customer Name: \n");
                      },
                      validator: (value){
                        //todo
                        print("Validating Customer Name\n");
                      }
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      initialValue: project.clientAddress,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onSaved: (value){
                        //todo
                        print("Address: \n");
                      },
                      validator: (value){
                        //todo
                        print("Validating Address\n");
                      }
                    ),
                  ),
                  Container(
                    height: 50,
                    padding: EdgeInsets.all(5),
                    child: TextFormField(
                      initialValue: project.description,
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onSaved: (value){
                        //todo
                        print("Description: \n");
                      },
                      validator: (value){
                        //todo
                        print("Validating Description\n");
                      }
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
                    //todo: add a room
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditRoom(room: Room())));
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
              child: ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, index){
                return Container(
                  margin: EdgeInsets.all(1),
                  decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(rooms[index].name),
                    trailing: Icon(Icons.edit),
                    onTap: () => {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditRoom(room: rooms[index])))
                    }, //todo - go to edit room page for clicked room
                  )
                );
              }),
            ),
          ]
        )
    );
    }
  }

  void getFakeData() {
    project = widget.project;
    if(project.id != null){
      rooms = FakeData().getRooms(project.id);
    }
    /* rooms.add(Room(name: "Bedroom", id: 1));
    rooms.add(Room(name: "Bathroom", id: 2));
    rooms.add(Room(name: "Kitchen", id: 3));
    Project fakeProject = Project(id: 1, name: "Test Project", clientName: "Sherlock", clientAddress: "221B Baker St.", description: "Painting Exterior");
    project = fakeProject; */
  }
}