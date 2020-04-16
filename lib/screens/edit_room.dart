import 'package:flutter/material.dart';
import 'package:project_estimator/screens/room_photo_gallery.dart';

class EditRoom extends StatelessWidget {

  static const routeName = 'edit_room';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Name'),
      ),
      body: Center(
        child: Row(
          children: [
            RaisedButton(
              onPressed: () {
                //todo: Add Photo
              },
              child: Text('Add Photo'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RoomPhotoGallery.routeName);
              },
              child: Text('View Photos'),
            ),
            RaisedButton(
              onPressed: () {
                //todo: Add Note
              },
              child: Text('Add Note'),
            ),
          ],
        ),
      )
    );
  }
}