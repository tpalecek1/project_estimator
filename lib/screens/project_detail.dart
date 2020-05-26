import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_estimator/screens/edit_project.dart';
import 'package:project_estimator/screens/project_estimate.dart';
import 'package:project_estimator/screens/project_notes.dart';
import 'package:project_estimator/screens/room_detail.dart';
import 'package:project_estimator/widgets/custom_button_1.dart';
import '../models/user.dart';
import '../models/project.dart';
import '../models/room.dart';
import 'package:project_estimator/services/database.dart';

class ProjectDetail extends StatefulWidget{
  ProjectDetail({Key key, this.userId, this.project}) : super(key: key);
  static const routeName = 'project_detail';
  final String userId;
  final Project project;
  @override
  _ProjectDetailState createState() => _ProjectDetailState();
}


class _ProjectDetailState extends State<ProjectDetail> {

  Project _project;
  List<Room> _rooms;
  StreamSubscription<Project> _projectStreamSubscription;
  StreamSubscription<List<Room>> _roomStreamSubscription;

  @override 
  void initState() { 
    super.initState();

    _project = widget.project;
    _listenForProject();
    _listenForProjectRooms();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(_project.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Project Description',
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.left,
            ),
            Container(
              width: screenWidth - 6,
              margin: EdgeInsets.only(top:3, bottom: 3),
              decoration: BoxDecoration(border: Border.all(width: 1.2), borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Row(
                        children:[
                          Text(
                            'Customer Name:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            )
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                          Text(
                            _project.clientName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            )
                          ),
                        ]
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Row(
                        children:[
                          Text(
                            'Address:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            )
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                          Text(
                            _project.clientAddress,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            )
                          ),
                        ]
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Row(
                        children:[
                          Text(
                            'Description:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            )
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                          Text(
                            _project.description,
                            maxLines: 3,
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            )
                          ),
                        ]
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Row(
                        children:[
                          Text(
                            'Status:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                            )
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
                          Text(
                            _project.status,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            )
                          ),
                        ]
                      ),
                    ),
                  ],
                ),
              )
            ),
            Container(
              width: screenWidth,
              height: 75,
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton1(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProject(project: _project, userId: widget.userId,)));
                      },
                      child: Text('Edit Project')
                    )
                  ),
                  Expanded(
                    child: CustomButton1(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectNotes(projectId: _project.id)));
                      },
                      child: Text('Show Project Notes')
                    )
                  ),
                  Expanded(
                    child: CustomButton1(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectEstimate(userId: widget.userId, project: _project, rooms: _rooms)));
                      },
                      child: Text('Show Project Estimate')
                    )
                  ),
                ],
              ),
            ),
            Container(
              width: screenWidth,
              height: 60,
                child: Container(
                  margin: EdgeInsets.only(left: 3),
                  child: Align(
                    child: Text(
                        'Rooms',
                        style: Theme.of(context).textTheme.display1
                    ),
                    alignment: Alignment.centerLeft
                  )
                )
            ),
            //todo: should be in the list, make fake listview data
            Container(
              width: screenWidth,
              child: _rooms == null ?
              Center(child: CircularProgressIndicator()) :
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('${_rooms[index].name}'),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoomDetail(room: _rooms[index])));
                      },
                    ),
                  );
                }
              ),
            ),
          ]
        ),
      ),
      
    );
  }


  void _listenForProject() {
    _projectStreamSubscription = Database().readProjectRealTime(_project.id).listen((project) {
      setState(() { _project = project; });
    });
  }

  void _listenForProjectRooms() {
    _roomStreamSubscription = Database().readRoomsRealTime(_project.id).listen((rooms) {
      rooms.sort((a, b) => (a.name).compareTo(b.name));
      setState(() { _rooms = rooms; });
    });
  }

  @override
  void dispose() {
    _projectStreamSubscription.cancel();
    _roomStreamSubscription.cancel();
    super.dispose();
  }
}