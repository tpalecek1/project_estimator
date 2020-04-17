import 'package:flutter/material.dart';
import 'package:project_estimator/screens/room_photo_gallery.dart';
import 'package:project_estimator/widgets/custom_button_1.dart';

class EditRoom extends StatelessWidget {

  static const routeName = 'edit_room';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Name'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 6,
            child: Placeholder()
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Row(
              children: [
                Expanded(
                  child: CustomButton1(
                    onPressed: () {
                      //todo: Add Photo
                    },
                    child: Text('Add Photo')
                  ),
                ),
                Expanded(
                  child: CustomButton1(
                    onPressed: () {
                      Navigator.of(context).pushNamed(RoomPhotoGallery.routeName);
                    },
                    child: Text('View Photos')
                  ),
                )
              ],
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Row(
              children: [
                Expanded(child: Container(child: Align(child: Text('Rooms Notes'), alignment: Alignment.centerLeft))),
                CustomButton1(
                  onPressed: () {
                    //todo: Add Note
                  },
                  child: Text('Add Note'),
                )
              ]
            )
          ),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Placeholder()
          ),
          Flexible(
            flex: 3,
            child: Placeholder()
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //todo
          Navigator.of(context).pop();
        },
        child: Icon(Icons.check),
      )
    );
  }
}