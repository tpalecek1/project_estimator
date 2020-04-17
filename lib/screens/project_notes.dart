import 'package:flutter/material.dart';

class ProjectNotes extends StatelessWidget {

  static const routeName = 'project_notes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Notes'),
      ),
      body: Container(
        child: Placeholder(),
      )
    );
  }
}