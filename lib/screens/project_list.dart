import 'package:flutter/material.dart';
import 'package:project_estimator/models/fake_data.dart';
import 'package:project_estimator/screens/project_detail.dart';
import 'package:project_estimator/screens/user_setting.dart';
import 'package:project_estimator/widgets/my_popup_menu.dart' as mypopup;
import '../models/fake_data.dart';
import '../models/project.dart';

import 'edit_project.dart';

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  TextEditingController controller = TextEditingController();
  bool showCancel = false;
  String _selectedCategory;
  //fake data
  List<Project> projects = FakeData().getProjects();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project List'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed(UserSetting.routeName);
            },
          )
        ],
      ),
      body: Column(
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
                          controller: controller,
                          decoration: InputDecoration(
                            hintText: 'Search', border: InputBorder.none, contentPadding: const EdgeInsets.only(left: 12, bottom: 12)
                          ),
                          onChanged: onSearchTextChanged,
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
                            showCancel = false;
                            setState((){});
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
                        //todo
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
                      tooltip: 'Select a category',
                      padding: EdgeInsets.all(0),
                      icon: Icon(Icons.filter_list),
                      onSelected: (newValue) {
                        FocusScope.of(context).requestFocus(FocusNode()); //to unfocus serach textField, weird way, check alternative way later
                        //widget.filter(newValue);
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return <String>['all', 'bid', 'not bid', 'awarded', 'not awarded', 'started', 'complete'].map((String choice) {
                          return mypopup.PopupMenuItem<String>(
                            value: choice,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: choice == _selectedCategory ? Colors.blue[100] : null,
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
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(DateTime.now().toString(), style: TextStyle(color: Colors.blue, fontSize: 12)),
                      // subtitle: Padding(
                      //   padding: const EdgeInsets.only(top: 8.0),
                      //   child: Text('${items[index]['projectName']}', style: TextStyle(fontSize: 18)),
                      // ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(text:'${projects[index].name}\n', style: TextStyle(fontSize: 18, color: Colors.black)),
                            TextSpan(text:'${projects[index].description}\n', style: TextStyle(fontSize: 16, color: Colors.black)),
                          ])
                        )
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${projects[index].status}', style: TextStyle(fontSize: 16))
                        ]
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProjectDetail(project: projects[index])));
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProject(project: Project())));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
  void onSearchTextChanged(String text) {
    //todo: search functionality
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
}

