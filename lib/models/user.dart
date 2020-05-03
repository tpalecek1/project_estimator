import 'package:project_estimator/models/paint_settings.dart';

class User {
  final String id;
  String name, company, address, phoneNumber, licenseNumber;
  PaintSettings paintSettings;

  User({
    this.id,
    this.name = "",
    this.company = "",
    this.address = "",
    this.phoneNumber = "",
    this.licenseNumber = "",
    PaintSettings paintSettings }) {
    this.paintSettings = paintSettings ?? PaintSettings();
  }

  User.fromMap(Map<String, dynamic> map, String userId) :
    id = userId,
    name = map['name'],
    company = map['company'],
    address = map['address'],
    phoneNumber = map['phoneNumber'],
    licenseNumber = map['licenseNumber'],
    paintSettings = PaintSettings.fromMap(map['paintSettings']);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'company': company,
      'address': address,
      'phoneNumber': phoneNumber,
      'licenseNumber': licenseNumber,
      'paintSettings': paintSettings.toMap(),
    };
  }


  @override
  bool operator==(Object other) =>
      other is User &&
      other.id == id &&
      other.name == name &&
      other.company == company &&
      other.address == address &&
      other.phoneNumber == phoneNumber &&
      other.licenseNumber == licenseNumber &&
      other.paintSettings == paintSettings;

  @override
  int get hashCode => id.hashCode^name.hashCode^company.hashCode^address.hashCode^
                      phoneNumber.hashCode^licenseNumber.hashCode^paintSettings.hashCode;
}