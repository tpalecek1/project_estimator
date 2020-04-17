import 'paint_settings.dart';

class User {
  String name, company, address, phoneNumber, licenseNumber;
  PaintSettings paintSettings;

  User({
    this.name,
    this.company,
    this.address,
    this.phoneNumber,
    this.licenseNumber,
    this.paintSettings
  });

  User.fromMap(dynamic map){
    name = map['name'];
    company = map['company'];
    address = map['address'];
    phoneNumber = map['phoneNumber'];
    licenseNumber = map['licenseNumber'];
    paintSettings = map['paintSettings'];
  }
}