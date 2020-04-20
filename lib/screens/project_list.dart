import 'package:flutter/material.dart';
import 'package:project_estimator/screens/project_detail.dart';
import 'package:project_estimator/screens/user_setting.dart';

import 'edit_project.dart';

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  TextEditingController controller = TextEditingController();
  bool showCancel = false;
  //fake list data
  final items = List<Map>.generate(100, (i) {
    return {
      'date':'Date $i',
      'projectName':'Project $i',
      'category':'category $i'
    };
  });

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
                      //splashColor: Colors.lightBlueAccent,
                      onTap: (){},
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
                    child: InkWell(
                      //splashColor: Colors.lightBlueAccent,
                      onTap: (){},
                      child: SizedBox(
                        width: 50,
                        child: Icon(
                            Icons.filter_list,
                            size: 30.0,
                            color: Colors.black,
                        ),
                      ),                    
                    ),
                  )
                )
              ),
            ])
          ),
          Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${items[index]['projectName']}'),
                  subtitle: Text('${items[index]['date']}'),
                  trailing: Text('${items[index]['category']}'),
                  onTap: () {
                    Navigator.of(context).pushNamed(ProjectDetail.routeName);
                  },
                );
              }
            ),
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(EditProject.routeName);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
  void onSearchTextChanged(String text) {
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

