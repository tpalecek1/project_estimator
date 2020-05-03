class ProjectNote {
  final String id;
  bool hasCost;
  String description;

  ProjectNote({
    this.id,
    this.hasCost = false,
    this.description = ""
  });

  ProjectNote.fromMap(Map<String, dynamic> map, String projectNoteId) :
    id = projectNoteId,
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
      other is ProjectNote &&
      /*other.id == id &&*/
      other.hasCost == hasCost &&
      other.description == description;

  @override
  int get hashCode => /*id.hashCode^*/hasCost.hashCode^description.hashCode;
}