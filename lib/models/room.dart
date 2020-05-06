class Room {
  final String id;
  String name;
  double ceilingHeight, length, width;
  int doorCount, windowCount, accentWallCount;
  bool hasCrown, hasChairRail, hasBaseboard;
  List<String> photos;

  Room({
    this.id,
    this.name = '',
    this.ceilingHeight = 0,
    this.length = 0,
    this.width = 0,
    this.doorCount = 0,
    this.windowCount = 0,
    this.accentWallCount = 0,
    this.hasCrown = false,
    this.hasChairRail = false,
    this.hasBaseboard = false,
    List<String> photos }) {
    this.photos = photos ?? List<String>();
  }

  Room.fromMap(Map<String, dynamic> map, String roomId) :
    id = roomId,
    name = map['name'],
    ceilingHeight = map['ceilingHeight'],
    length = map['length'],
    width = map['width'],
    doorCount = map['doorCount'],
    windowCount = map['windowCount'],
    accentWallCount = map['accentWallCount'],
    hasCrown = map['hasCrown'],
    hasChairRail = map['hasChairRail'],
    hasBaseboard = map['hasBaseboard'],
    photos = List.from(map['photos']);

  Map<String, dynamic> toMap() {
    return {
    'name': name,
    'ceilingHeight': ceilingHeight,
    'length': length,
    'width': width,
    'doorCount': doorCount,
    'windowCount': windowCount,
    'accentWallCount': accentWallCount,
    'hasCrown': hasCrown,
    'hasChairRail': hasChairRail,
    'hasBaseboard': hasBaseboard,
    'photos': photos
    };
  }

  void addPhoto(String url){
    photos.add(url);
  }

  void removePhoto(String url){
    photos.remove(url);
  }

  double ceilingArea(){
    return length * width;
  }

  double wallArea(){
    return (length * 2) + (width * 2) * ceilingHeight;
  }

  double trimLength(){
    double base, chair, crown = 0;
    if(hasBaseboard) base = (length * 2) + (width * 2);
    if(hasChairRail) chair = (length * 2) + (width * 2);
    if(hasCrown) crown = (length * 2) + (width * 2);
    return base + chair + crown;
  }


  @override
  bool operator==(Object other) =>
      other is Room &&
          /*other.id == id &&*/
          other.name == name &&
          other.ceilingHeight == ceilingHeight &&
          other.length == length &&
          other.width == width &&
          other.doorCount == doorCount &&
          other.windowCount == windowCount &&
          other.accentWallCount == accentWallCount &&
          other.hasCrown == hasCrown &&
          other.hasChairRail == hasChairRail &&
          other.hasBaseboard == hasBaseboard &&
          other.photos.join() == photos.join();

  @override
  int get hashCode => /*id.hashCode^*/name.hashCode^ceilingHeight.hashCode^
                      length.hashCode^width.hashCode^doorCount.hashCode^
                      windowCount.hashCode^accentWallCount.hashCode^
                      hasCrown.hashCode^hasChairRail.hashCode^hasBaseboard.hashCode^
                      photos.join().hashCode;
}