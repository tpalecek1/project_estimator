import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:project_estimator/models/room.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:project_estimator/services/database.dart';

//reference: https://22v.net/article/3246/
class RoomPhotoGallery extends StatelessWidget {
  RoomPhotoGallery({Key key, this.roomId}) : super(key: key);
  static const routeName = 'room_photo_gallery';
  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Photo Gallery'),
      ),
      body: GalleryScreen(roomId: roomId),
      
    );
  }
}

class GalleryScreen extends StatefulWidget {
  GalleryScreen({Key key, this.roomId}) : super(key: key);
  final String roomId;
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  Room room;
  StreamSubscription<Room> _roomStreamSubscription;
  bool _roomIsModified = false;

  @override
  void initState() {
    super.initState();

    _listenForRoom();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, _roomIsModified);
        return false;
      },
      child: room == null ?
      Center(child: CircularProgressIndicator()) :
      Container(
          child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                    delegate: HeroHeader(
                        minExtent: 100.0, //when more, header get exapnd height until maxExtant reaches; when less, no shrink, just move away
                        maxExtent: 250.0, // header expand to most this height
                        roomName: room.name
                    )
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent( //set the size of each grid child
                    maxCrossAxisExtent: 250.0, //each occpuies the max high possible?
                    mainAxisSpacing: 1, //sapce vertically
                    crossAxisSpacing: 1, //space horizontally
                    childAspectRatio: 1, //this gives each child square shape (width/height = 1)
                  ),
                  delegate: SliverChildBuilderDelegate( //set each grid child layout
                        (context,index) {
                      return Stack(
                        children:[
                          Center(child: CircularProgressIndicator()), //follow Flutter documentation, but it is weird to keep this running
                          Container(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                      return PhotoBigView(
                                        initialIndex: index,
                                        photoList: room.photos,
                                      );
                                    }));
                                  },
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: room.photos[index],
                                    height: 250.0,
                                    width: 250.0,
                                    fit: BoxFit.cover,
                                  )
                              )
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Text('Are you sure to delete this photo?'),
                                            actions: [
                                              FlatButton(
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('cancel')
                                              ),
                                              FlatButton(
                                                  onPressed: (){
                                                    room.photos.remove(room.photos[index]);
                                                    Database().updateRoom(room);
                                                    _roomIsModified = true;
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('ok')
                                              ),

                                            ],
                                          );
                                        }
                                    );
                                  },
                                  child: Icon(Icons.delete_forever, color: Colors.red)
                              )
                          )
                        ],
                      );
                    },
                    childCount: room.photos.length,
                  ),
                ),

              ]
          )
      ),
    );
  }

  void _listenForRoom() {
    _roomStreamSubscription = Database().readRoomRealTime(widget.roomId).listen((_room) {
      setState(() { room = _room; });
    });
  }

  @override
  void dispose() {
    _roomStreamSubscription?.cancel();
    super.dispose();
  }
}

class HeroHeader implements SliverPersistentHeaderDelegate {

  //exapnd and shrink factors
  double maxExtent;
  double minExtent;
  String roomName;

  HeroHeader({this.maxExtent, this.minExtent, this.roomName});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    String roomImage = 'assets/images/intro.jpg';
    if (roomName.toLowerCase().contains('living')) {
      roomImage = 'assets/images/living_room.jpg';
    } else if (roomName.toLowerCase().contains('bed')) {
      roomImage = 'assets/images/bedroom.jpg';
    } else if (roomName.toLowerCase().contains('bath')) {
      roomImage = 'assets/images/bathroom.jpg';
    } else if (roomName.toLowerCase().contains('garage')) {
      roomImage = 'assets/images/garage.jpg';
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          roomImage,
          fit: BoxFit.cover,
        ),
        Container( //has a transparent white and black gradient on top of image to make it look nicer
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.black54,
              ],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          child: Text(roomName, style: TextStyle(fontSize: 32.0, color: Colors.white)
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  // TODO: implement snapConfiguration  //time: research the function of this
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  // TODO: implement stretchConfiguration  //time: research the function of this
  OverScrollHeaderStretchConfiguration get stretchConfiguration => null;
}

class PhotoBigView extends StatefulWidget {
  final int initialIndex;
  final List<String> photoList;
  final PageController pageController;

  PhotoBigView({this.initialIndex, this.photoList}) :  //interesting, initializtion list can set final value
    pageController = PageController(initialPage: initialIndex);
  
  @override
  _PhotoBigViewState createState() => _PhotoBigViewState();
}

class _PhotoBigViewState extends State<PhotoBigView> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            itemCount: widget.photoList.length, 
            onPageChanged: onPageChanged,
            pageController: widget.pageController,
            builder: (context, index){
              return PhotoViewGalleryPageOptions.customChild( //adjust pictures' sizes to the same size
                child: Image(image: NetworkImage(widget.photoList[index]), fit: BoxFit.cover,
                  loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        value: loadingProgress.expectedTotalBytes != null ?
                        loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                            : null,
                      ),
                    );
                  },
                ),
                minScale: PhotoViewComputedScale.contained * 0.6, //shrink to this min number and no less  (time: study how it operate to get contained)
                maxScale: PhotoViewComputedScale.covered * 1.1, //expand to this max number and no more
                initialScale: PhotoViewComputedScale.contained, //initial size
                childSize: const Size(300, 250),
              );
            }
          )
        ),
        Positioned(
          top: 30,
          left: 0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(width: 50, height:50, child: Icon(Icons.arrow_back, color: Colors.white))
          )
        )        
      ]
    );
  }
}

