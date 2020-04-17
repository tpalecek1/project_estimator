import 'package:flutter/material.dart';
import 'package:project_estimator/screens/edit_room.dart';
import 'package:project_estimator/screens/project_notes.dart';
import 'package:project_estimator/widgets/custom_button_1.dart';

class EditProject extends StatelessWidget {

  static const routeName = 'edit_project';

  @override
  Widget build(BuildContext context) {

    //fake rooms data
    var roomList = getFakeData(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Project: Project Name'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 5,
            child: Placeholder()
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
                      //todo: add project note
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
                },
                child: Text('Add Room'),
              )
            )
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(child: Align(child: Text('Rooms List'), alignment: Alignment.centerLeft))
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: SingleChildScrollView(
              child: Wrap(
                children: roomList
              ),
            )
          ),
          Flexible(
            flex: 3,
            child: Placeholder()
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //todo
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      )
    );
  }

  List<Widget> getFakeData(BuildContext context) {
    var roomList = List<Widget>.generate(9, (i){
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: RaisedButton(
          onPressed: (){
            Navigator.of(context).pushNamed(EditRoom.routeName);
          },
          child: Text('Room ${i+1}'),
        ),
      );
    });
    return roomList; 
  }
}