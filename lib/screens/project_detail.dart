import 'package:flutter/material.dart';
import 'package:project_estimator/screens/edit_project.dart';
import 'package:project_estimator/screens/project_estimate.dart';
import 'package:project_estimator/screens/project_notes.dart';
import 'package:project_estimator/screens/room_detail.dart';

class ProjectDetail extends StatelessWidget {

  static const routeName = 'project_detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Name'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(EditProject.routeName);
                    },
                    child: Text('Edit Project Button'),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ProjectNotes.routeName);
                    },
                    child: Text('Show Project Notes Button'),
                  ),
                ),
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ProjectEstimate.routeName);
                    },
                    child: Text('Show Project Estimate Button'),
                  ),
                ),
              ],
            ),
            //todo: should be in the list, make fake listview data
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RoomDetail.routeName);
              },
              child: Text('xxx Room'),
            ),
          ]
        ),
      )
    );
  }
}
