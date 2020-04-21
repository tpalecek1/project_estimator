import 'package:flutter/material.dart';
import 'package:project_estimator/screens/project_detail.dart';
import 'package:project_estimator/screens/user_setting.dart';
import 'package:project_estimator/widgets/my_popup_menu.dart' as mypopup;

import 'edit_project.dart';

class ProjectList extends StatefulWidget {
  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  TextEditingController controller = TextEditingController();
  bool showCancel = false;
  String _selectedCategory;
  //fake list data
  final items = List<Map>.generate(100, (i) {
    return {
      'date':'2020-04-21 08:00',
      'projectName':'Project $i',
      'category': category(i)
    };
  });
  static String category(int i) {
    i = i%6;
    switch(i) {
      case 0:
        return "bid";
      case 1:
        return "not bid";
      case 2:
        return "awarded";
      case 3:
        return "not awarded";
      case 4:
        return "started";
      case 5:
        return "complete";
    }
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
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text('${items[index]['date']}', style: TextStyle(color: Colors.blue, fontSize: 12)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${items[index]['projectName']}', style: TextStyle(fontSize: 18)),
                      ),
                      trailing: Text('${items[index]['category']}', style: TextStyle(fontSize: 16)),
                      onTap: () {
                        Navigator.of(context).pushNamed(ProjectDetail.routeName);
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
          Navigator.of(context).pushNamed(EditProject.routeName);
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

