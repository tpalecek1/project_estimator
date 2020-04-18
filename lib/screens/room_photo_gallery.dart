import 'package:flutter/material.dart';

class RoomPhotoGallery extends StatelessWidget {

  static const routeName = 'room_photo_gallery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Photo Gallery'),
      ),
      body: Container(
        child: Placeholder(),
      )
    );
  }
}