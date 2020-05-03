import 'package:flutter/material.dart';
import 'package:project_estimator/screens/room_photo_gallery.dart';
import '../models/room.dart';
import '../models/room_note.dart';
import '../widgets/custom_button_1.dart';
import '../models/fake_data.dart';

class RoomDetail extends StatefulWidget{
  RoomDetail({Key key, this.room}) : super(key: key);
  static const routeName = 'room_detail';
  final Room room;

  @override
  _RoomDetailState createState() => _RoomDetailState();
}


class _RoomDetailState extends State<RoomDetail> {
  Room room;
  List<RoomNote> notes = [];

  @override 
  void initState() { 
    super.initState();
    getData();
  }

  void getData() async {
    await Future.delayed(const Duration(seconds: 1)); //Simulating delay from getting data
    getFakeData();
    setState((){});
  }
  

  @override
  Widget build(BuildContext context) {
    return waitData();
  }

  Widget waitData() {
    if(room == null){
      return Center(
        child: CircularProgressIndicator()
      );
    }
    else{
    return Scaffold(
      appBar: AppBar(
        title: Text(room.name),
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
                            room.ceilingHeight.toString(), 
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
                            room.length.toString(), 
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
                            room.width.toString(), 
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
                            room.doorCount.toString(), 
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
                            room.windowCount.toString(), 
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
                            room.accentWallCount.toString(), 
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
                            room.hasBaseboard.toString(), 
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
                            room.hasChairRail.toString(), 
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
                            room.hasCrown.toString(), 
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
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('${notes[index].description}'),
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
  void getFakeData(){
    room = widget.room;
    notes = FakeData().getRoomNotes(room.id);
    /* notes.add(RoomNote(id: 0, description: 'Painting Cabinets'));
    notes.add(RoomNote(id: 1, description: 'De-grease walls'));
    notes.add(RoomNote(id: 2, description: 'Hard-to-reach areas'));
    notes.add(RoomNote(id: 3, description: 'Lots of masking'));
    notes.add(RoomNote(id: 4, description: 'Minor drywall damage')); */
  }
}