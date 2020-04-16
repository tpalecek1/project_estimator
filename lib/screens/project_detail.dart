import 'package:flutter/material.dart';
import 'package:project_estimator/screens/edit_project.dart';
import 'package:project_estimator/screens/project_estimate.dart';
import 'package:project_estimator/screens/project_notes.dart';
import 'package:project_estimator/screens/room_detail.dart';

class ProjectDetail extends StatelessWidget {

  static const routeName = 'project_detail';

  //fake room data
  final rooms = [{'name': 'Living Room'},
                 {'name': 'BedRoom'},
                 {'name': 'Kitchen'},
                 {'name': 'Master Bathroom'}];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Name'),
        actions: [
          Center(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(child: Placeholder(), width: 100),
          ))
        ],
      ),
      body: Column(
        children: [
          Flexible(
            flex: 2,
            child: Placeholder()
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Row(
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
          ),
          Flexible(
            flex: 3,
            child: Placeholder()
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(child: Align(child: Text('Rooms'), alignment: Alignment.centerLeft,))
          ),
          //todo: should be in the list, make fake listview data
          Flexible(
            flex: 3,
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('${rooms[index]['name']}'),
                    onTap: () {
                      Navigator.of(context).pushNamed(RoomDetail.routeName);
                    },
                  ),
                );
              }
            ),
          ),
        ]
      ),
    );
  }
}
