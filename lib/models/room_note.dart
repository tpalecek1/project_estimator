class RoomNote{
  final String id;
  bool hasCost;
  String description;

  RoomNote({
    this.id,
    this.hasCost = false,
    this.description = ""
  });

  RoomNote.fromMap(Map<String, dynamic> map, String roomNoteId) :
    id = roomNoteId,
    hasCost = map['hasCost'],
    description = map['description'];

  Map<String, dynamic> toMap() {
    return {
      'hasCost': hasCost,
      'description': description,
    };
  }


  @override
  bool operator==(Object other) =>
      other is RoomNote &&
      /*other.id == id &&*/
      other.hasCost == hasCost &&
      other.description == description;

  @override
  int get hashCode => /*id.hashCode^*/hasCost.hashCode^description.hashCode;
}