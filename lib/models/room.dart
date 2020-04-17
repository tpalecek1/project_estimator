import 'room_note.dart';

class Room {
  String name;
  double ceilingHeight, length, width;
  int doorCount, windowCount, accentWallCount;
  bool hasCrown, hasChairRail, hasBaseboard;
  List<String> photos;
  List<RoomNote> roomNotes;

  Room({
    this.name = 'Room',
    this.ceilingHeight,
    this.length = 0,
    this.width = 0,
    this.doorCount = 0,
    this.windowCount = 0,
    this.accentWallCount = 0,
    this.hasCrown = false,
    this.hasChairRail = false,
    this.hasBaseboard = false,
    this.photos,
    this.roomNotes
  });

  Room.fromMap(dynamic map){
    name = map['Room'];
    ceilingHeight = map['ceilingHeight'];
    length = map['length'];
    width = map['width'];
    doorCount = map['doorCount'];
    windowCount = map['windowCount'];
    accentWallCount = map['accentWallCount'];
    hasCrown = map['hasCrown'];
    hasChairRail = map['hasChairRail'];
    hasBaseboard = map['hasBaseboard'];
    photos = map['photos'];
    roomNotes = map['roomNotes'];
  }
}