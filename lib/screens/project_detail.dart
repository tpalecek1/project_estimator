import 'package:flutter/material.dart';
import 'package:project_estimator/screens/edit_project.dart';
import 'package:project_estimator/screens/project_estimate.dart';
import 'package:project_estimator/screens/project_notes.dart';
import 'package:project_estimator/screens/room_detail.dart';
import 'package:project_estimator/widgets/custom_button_1.dart';
import '../models/project.dart';
import '../models/room.dart';
import '../models/fake_data.dart';

class ProjectDetail extends StatefulWidget{
  ProjectDetail({Key key, this.project}) : super(key: key);
  static const routeName = 'project_detail';
  final Project project;
  @override
  _ProjectDetailState createState() => _ProjectDetailState();
}


class _ProjectDetailState extends State<ProjectDetail> {

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
  Widget build(BuildContext context) {
    return waitData();
  }

  Widget waitData(){
    if(project == null){
      return Center(
        child: CircularProgressIndicator()
      );
    }
    else{
      return Scaffold(
      appBar: AppBar(
        title: Text(project.name),
      ),
      body: Column(
        children: [
          Text(
            'Project Description',
            style: Theme.of(context).textTheme.display1,
            textAlign: TextAlign.left,
          ),
          Flexible(
            flex: 3,
            child: Container(
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(border: Border.all(width: 1.2), borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    dense: true,
                    title: Row(
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
                          project.clientName, 
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.w400,
                          )
                        ),
                      ]
                      ),
                  ),
                  ListTile(
                    dense: true,
                    title: Row(
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
                          project.clientAddress, 
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.w400,
                          )
                        ),
                      ]
                      ),
                  ),
                  ListTile(
                    dense: true,
                    title: Row(
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
                          project.description, 
                          style: TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.w400,
                          )
                        ),
                      ]
                      ),
                  ),
                ],
              )
            )
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              children: [
                Expanded(
                  child: CustomButton1(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProject(project: project)));
                    },
                    child: Text('Edit Project')
                  )
                ),
                Expanded(
                  child: CustomButton1(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ProjectNotes.routeName);
                    },
                    child: Text('Show Project Notes')
                  )
                ),
                Expanded(
                  child: CustomButton1(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectEstimate(project: project, rooms: rooms)));
                    },
                    child: Text('Show Project Estimate')
                  )
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
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
          Flexible(
            flex: 3,
            child: ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('${rooms[index].name}'),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoomDetail(room: rooms[index])));
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

  void getFakeData(){
    project = widget.project;
    FakeData fakeData = FakeData();
    rooms = fakeData.getRooms(project.id);
  }
}