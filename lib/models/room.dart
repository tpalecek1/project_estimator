class Room {
  int id;
  String name;
  double ceilingHeight, length, width;
  int doorCount, windowCount, accentWallCount;
  bool hasCrown, hasChairRail, hasBaseboard;
  List<String> photos;

  Room({
    this.id,
    this.name = 'Room',
    this.ceilingHeight = 0,
    this.length = 0,
    this.width = 0,
    this.doorCount = 0,
    this.windowCount = 0,
    this.accentWallCount = 0,
    this.hasCrown = false,
    this.hasChairRail = false,
    this.hasBaseboard = false,
    this.photos,
  });

  Room.fromMap(dynamic map){
    id = map['id'];
    name = map['name'];
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
}