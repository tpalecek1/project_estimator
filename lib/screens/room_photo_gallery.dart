import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:project_estimator/models/room.dart';
import 'package:transparent_image/transparent_image.dart';

class RoomPhotoGallery extends StatelessWidget {

  static const routeName = 'room_photo_gallery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Photo Gallery'),
      ),
      body: GalleryScreen(),
      
    );
  }
}

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<String> images;

  @override
  void initState() {
    images = getImages(); //get faked data
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: HeroHeader(
              minExtent: 100.0, //when more, header get exapnd height until maxExtant reaches; when less, no shrink, just move away
              maxExtent: 250.0 // header expand to most this height
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
                          //todo
                          
                        },
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: images[index],
                          height: 250.0,
                          width: 250.0,
                          fit: BoxFit.cover,
                        ),
                        // child: FadeInImage.assetNetwork(
                        //   placeholder: 'assets/images/loading.gif', //too big? find a way to fix later
                        //   image: images[index],
                        //   height: 250.0,
                        //   width: 250.0,
                        //   fit: BoxFit.cover,
                        // )
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
                                      setState(() {
                                        //todo: delete an image
                                        images.remove(images[index]);
                                      });
                                      Navigator.of(context).pop();
                                    }, 
                                    child: Text('ok')
                                  ),
                                
                                ],
                              );
                            }
                          );
                        },
                        child: Icon(Icons.delete)
                      )
                    )
                  ],
                );
              },
              childCount: images.length,
            ),
          ),

        ]
      )
    );
  }
  List<String> getImages() {
    Room room = Room();
    List<String> photos = List();
    //make faked images data in room
    photos.add('https://firebasestorage.googleapis.com/v0/b/wasteagram-18a5f.appspot.com/o/2020-04-30%2018%3A19%3A30.170261?alt=media&token=40879f95-13cf-4345-9a98-074574d30b7d');
    photos.add('https://firebasestorage.googleapis.com/v0/b/wasteagram-18a5f.appspot.com/o/2020-04-30%2018%3A18%3A51.731015?alt=media&token=e4d2be5e-cf0c-448b-bf8b-3eb250f96a74');
    photos.add('https://firebasestorage.googleapis.com/v0/b/wasteagram-18a5f.appspot.com/o/2020-04-30%2018%3A20%3A17.160801?alt=media&token=38dd7a3c-ba34-4d52-8385-bfa1247adfbf');
    photos.add('https://firebasestorage.googleapis.com/v0/b/wasteagram-18a5f.appspot.com/o/2020-03-17%2005%3A24%3A38.249222?alt=media&token=514559cf-ad73-4692-8d22-7568a0f26089');
    photos.add('https://firebasestorage.googleapis.com/v0/b/wasteagram-18a5f.appspot.com/o/2020-04-30%2018%3A21%3A03.694362?alt=media&token=59f9d37d-0340-477f-a1fd-51012b1174e7');
    room.photos = photos;
    return room.photos;
  }
}

class HeroHeader implements SliverPersistentHeaderDelegate {

  //exapnd and shrink factors
  double maxExtent;
  double minExtent;

  HeroHeader({this.maxExtent, this.minExtent});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/intro.jpg',
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
          child: Text('Room photo Gallery', style: TextStyle(fontSize: 32.0, color: Colors.white)
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

