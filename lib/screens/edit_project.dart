import 'package:flutter/material.dart';
import 'package:project_estimator/screens/edit_room.dart';
import 'package:project_estimator/screens/project_notes.dart';

class EditProject extends StatelessWidget {

  static const routeName = 'edit_project';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Project: Project Name'),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(ProjectNotes.routeName);
                },
                child: Text('View Project Notes'),
              ),
            ),
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  //todo: add project note
                },
                child: Text('Add Project Note'),
              ),
            ),
            Expanded(
              child: RaisedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditRoom.routeName);
                },
                child: Text('Add Room'),
              ),
            ),
          ],
        ),
      )
    );
  }
}