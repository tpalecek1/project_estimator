class ProjectNote {
  int id;
  bool hasCost;
  String description;

  ProjectNote({
    this.id,
    this.hasCost = false,
    this.description = ""
  });

  ProjectNote.fromMap(dynamic map){
    id = map['id'];
    hasCost = map['hasCost'];
    description = map['description'];
  }
}