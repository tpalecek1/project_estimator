import 'package:flutter/material.dart';
import 'package:project_estimator/screens/project_detail.dart';
import 'package:project_estimator/screens/user_setting.dart';

class ProjectList extends StatelessWidget {
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
      body: Center(
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
        )
      )
    );
    
  }
}