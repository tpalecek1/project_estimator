class RoomNote{
  bool hasCost;
  String description;

  RoomNote({
    this.hasCost = false,
    this.description = ""
  });

  RoomNote.fromMap(dynamic map){
    hasCost = map['hasCost'];
    description = map['description'];
  }
}