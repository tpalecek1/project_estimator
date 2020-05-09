import 'dart:async';
import 'package:flutter/material.dart';
import 'package:project_estimator/screens/room_photo_gallery.dart';
import '../models/room.dart';
import '../models/room_note.dart';
import '../widgets/custom_button_1.dart';
import 'package:project_estimator/services/database.dart';

class RoomDetail extends StatefulWidget{
  RoomDetail({Key key, this.room}) : super(key: key);
  static const routeName = 'room_detail';
  final Room room;

  @override
  _RoomDetailState createState() => _RoomDetailState();
}


class _RoomDetailState extends State<RoomDetail> {
  Room _room;
  List<RoomNote> _notes;

  @override 
  void initState() { 
    super.initState();

    _room = widget.room;
    Database().readRoomNotes(_room.id)
    .then((notes) {
      notes.sort((a, b) => (a.description).compareTo(b.description));
      setState(() { _notes = notes; });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_room.name),
      ),
      body: Column(
          children: [
            Text(
              'Room Details',
              style: Theme.of(context).textTheme.display1,
              textAlign: TextAlign.left,
            ),
            Flexible(
                flex: 3,
                child: Container(
                    padding: EdgeInsets.all(3),
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(border: Border.all(width: 1.2), borderRadius: BorderRadius.circular(10)),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                  children:[
                                    Text(
                                        'Ceiling Height:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                                    Text(
                                        _room.ceilingHeight.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )
                                    ),
                                  ]
                              ),
                              Row(
                                  children:[
                                    Text(
                                        'Length:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                                    Text(
                                        _room.length.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )
                                    ),
                                  ]
                              ),
                              Row(
                                  children:[
                                    Text(
                                        'Width:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                                    Text(
                                        _room.width.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )
                                    ),
                                  ]
                              ),
                              Row(
                                  children:[
                                    Text(
                                        'Doors:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                                    Text(
                                        _room.doorCount.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )
                                    ),
                                  ]
                              ),
                              Row(
                                  children:[
                                    Text(
                                        'Windows:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                                    Text(
                                        _room.windowCount.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )
                                    ),
                                  ]
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  children:[
                                    Text(
                                        'Accent Walls:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                                    Text(
                                        _room.accentWallCount.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )
                                    ),
                                  ]
                              ),
                              Row(
                                  children:[
                                    Text(
                                        'Baseboards:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                                    Text(
                                        _room.hasBaseboard.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )
                                    ),
                                  ]
                              ),
                              Row(
                                  children:[
                                    Text(
                                        'Chair Rail:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                                    Text(
                                        _room.hasChairRail.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )
                                    ),
                                  ]
                              ),
                              Row(
                                  children:[
                                    Text(
                                        'Crown Molding:',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                          decoration: TextDecoration.underline,
                                        )
                                    ),
                                    Padding(padding: EdgeInsets.symmetric(vertical: 15, horizontal: 3)),
                                    Text(
                                        _room.hasCrown.toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w400,
                                        )
                                    ),
                                  ]
                              ),
                            ],
                          )
                        ]
                    )
                )
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Row(
                children: [
                  Expanded(
                      child: CustomButton1(
                          onPressed: () {
                            Navigator.of(context).pushNamed(RoomPhotoGallery.routeName);
                          },
                          child: Text('Room Photos')
                      )
                  ),
                ],
              ),
            ),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                    margin: EdgeInsets.only(left: 3),
                    child: Align(
                        child: Text(
                            'Notes',
                            style: Theme.of(context).textTheme.display1
                        ),
                        alignment: Alignment.centerLeft
                    )
                )
            ),
            Flexible(
              flex: 4,
              child: _notes == null ?
              Center(child: CircularProgressIndicator()) :
              ListView.builder(
                  itemCount: _notes.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text('${_notes[index].description}'),
                        onTap: () {
                          //
                        },
                      ),
                    );
                  }
              ),
            ),
          ]
      ),
    );
  }
}