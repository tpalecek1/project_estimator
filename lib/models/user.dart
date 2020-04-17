import 'paint_settings.dart';
import 'project.dart';

class User {
  String name, company, address, phoneNumber, licenseNumber;
  PaintSettings paintSettings;
  List<Project> projects;

  User({
    this.name = "",
    this.company = "",
    this.address = "",
    this.phoneNumber = "",
    this.licenseNumber = "",
    this.paintSettings,
    this.projects
  });

  User.fromMap(dynamic map){
    name = map['name'];
    company = map['company'];
    address = map['address'];
    phoneNumber = map['phoneNumber'];
    licenseNumber = map['licenseNumber'];
    paintSettings = map['paintSettings'];
    projects = map['projects'];
  }

  void addProject(Project project){
    //todo - add project to database
    projects.add(project);
  }

  void removeProject(Project project){
    //todo - remove project from database
    projects.remove(project);
  }
}