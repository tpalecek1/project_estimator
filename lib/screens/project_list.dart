import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_estimator/screens/project_detail.dart';
import 'package:project_estimator/screens/user_setting.dart';
import 'package:project_estimator/screens/edit_project.dart';
import 'package:project_estimator/widgets/my_popup_menu.dart' as mypopup;
import 'package:project_estimator/models/project.dart';
import 'package:project_estimator/services/database.dart';

class ProjectList extends StatefulWidget {
  ProjectList({Key key, this.userId}) : super(key: key);
  final String userId;
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  TextEditingController controller = TextEditingController();
  bool showCancel = false;
  String _selectedStatus = 'all';
  String _searchWord = "";

  StreamSubscription<List<Project>> _projectStreamSubscription;
  List<Project> _projects;

  List<Project> filteredProjects;


  @override
  void initState() {
    super.initState();

    _listenForProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project List'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode()); //to unfocus serach textField, weird way
              Navigator.of(context).pushNamed(UserSetting.routeName);
            },
          )
        ],
      ),
      body: _projects == null ?
      Center(child: CircularProgressIndicator()) :
      Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 4, top: 4, bottom: 4),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blue, width: 1),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Row(
                    children:[
                      Expanded(
                        child: TextField(
                          textInputAction: TextInputAction.search,
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Search', border: InputBorder.none, contentPadding: const EdgeInsets.only(left: 12, bottom: 12)
                          ),
                          onChanged: onSearchTextChanged,
                          onEditingComplete: (){filter();FocusScope.of(context).unfocus();},                          
                        ),
                      ),
                      Visibility(
                        visible: showCancel,
                        child: IconButton(
                          padding: EdgeInsets.only(bottom: 2),
                          color: Colors.blue,
                          icon: Icon(Icons.cancel), 
                          onPressed: () {
                            controller.clear();
                            _searchWord = "";
                            showCancel = false;
                            filter();
                        })
                      ),
                    ]
                  ),
                ),
              )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  child: Ink(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                    ),
                    child: InkWell(
                      onTap: (){
                        filter();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: SizedBox(
                        width: 50,
                        child: Icon(
                            Icons.search,
                            size: 30.0,
                            color: Colors.black,
                        ),
                      ),                    
                    ),
                  )
                )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  child: Ink(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                    ),
                    child: mypopup.PopupMenuButton<String>(
                      elevation: 20,
                      tooltip: 'Select a status',
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.filter_list),
                      onSelected: (newValue) {
                        FocusScope.of(context).requestFocus(FocusNode()); //to unfocus serach textField, weird way, check alternative way later
                        //widget.filter(newValue);
                        _selectedStatus = newValue;
                        filter();
                      },
                      onCanceled: (){FocusScope.of(context).requestFocus(FocusNode());}, //to unfocus serach textField
                      itemBuilder: (BuildContext context) {
                        return <String>['all', 'bid', 'not bid', 'awarded', 'not awarded', 'started', 'complete'].map((String choice) {
                          return mypopup.PopupMenuItem<String>(
                            value: choice,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: choice == _selectedStatus ? Colors.blue[100] : null,
                              child: Center(child: Text(choice)) //must use Center for this custom popup widget, otherwise strange layout appear
                            ),
                          );
                        }).toList();
                      },
                    )
                  )
                )
              ),
            ])
          ),
          Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProjects.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(filteredProjects[index].dateString(), style: TextStyle(color: Colors.blue, fontSize: 12)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(text:'${filteredProjects[index].name}\n', style: TextStyle(fontSize: 18, color: Colors.black)),
                            TextSpan(text:'${filteredProjects[index].description}\n', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ])
                        )
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${filteredProjects[index].status}', style: TextStyle(fontSize: 16))
                        ]
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetail(project: filteredProjects[index])));
                      },
                    ),
                    Divider(height: 1)
                  ]
                );
              }
            ),
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode()); //to unfocus serach textField, weird way
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProject(userId: widget.userId, project: Project())));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
  void onSearchTextChanged(String text) {
    _searchWord = text;
    if(text.isEmpty) {
      showCancel = false;
      setState(() {});
      return;
    } else {
      showCancel = true;
      setState(() {});
      return;
    }
  }

  void filter() {
    // print(_searchWord);
    setState(() {
      if(_selectedStatus == 'all' && _searchWord.isEmpty) { //if filter 'all', and search '', go here
        filteredProjects = _projects;
      } else if(_selectedStatus != 'all' && _searchWord.isEmpty) { //if filter a specific status, and search '', go here
        filteredProjects = _projects.where((project)=>project.status.toLowerCase() == (_selectedStatus.toLowerCase())).toList();
      } else if (_selectedStatus == 'all' && _searchWord.isNotEmpty) { //if filter 'all', and search a specific keyword, go here
        filteredProjects = _projects.where((project)=>project.name.toLowerCase().contains(_searchWord.toLowerCase())
                                                  ||project.description.toLowerCase().contains(_searchWord.toLowerCase())
                                                  ||project.dateString().contains(_searchWord)).toList();
      } else if (_selectedStatus != 'all' && _searchWord.isNotEmpty){ //if filter a specific status, and search a specific keyword, go here
        //print(filteredProjects[0].status);
        filteredProjects = _projects.where((project)=>project.status.toLowerCase() == (_selectedStatus.toLowerCase())).toList();
        filteredProjects = filteredProjects.where((project)=>project.name.toLowerCase().contains(_searchWord.toLowerCase())
                                                  ||project.description.toLowerCase().contains(_searchWord.toLowerCase())
                                                  ||project.dateString().contains(_searchWord)).toList();
      } 
    });
  }

  void _listenForProjects() {
    _projectStreamSubscription = Database().readProjectsRealTime(widget.userId).listen((projects) {
      projects.sort((a, b) => (a.date).compareTo(b.date) != 0 ? (a.date).compareTo(b.date) : (a.name).compareTo(b.name));
      _projects = projects;
      filter();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _projectStreamSubscription.cancel();
    super.dispose();
  }
}

