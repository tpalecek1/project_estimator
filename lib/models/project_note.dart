class ProjectNote {
  bool hasCost;
  String description;

  ProjectNote({
    this.hasCost = false,
    this.description = ""
  });

  ProjectNote.fromMap(dynamic map){
    hasCost = map['hasCost'];
    description = map['description'];
  }
}