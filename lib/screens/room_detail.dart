import 'package:flutter/material.dart';
import 'package:project_estimator/screens/room_photo_gallery.dart';

class RoomDetail extends StatelessWidget {

  static const routeName = 'room_detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('xxx Room'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(RoomPhotoGallery.routeName);
          },
          child: Text('View Photos'),
        )
      )
    );
  }
}