class RoomNote{
  int id;
  bool hasCost;
  String description;

  RoomNote({
    this.id,
    this.hasCost = false,
    this.description = ""
  });

  RoomNote.fromMap(dynamic map){
    id = map['id'];
    hasCost = map['hasCost'];
    description = map['description'];
  }
}