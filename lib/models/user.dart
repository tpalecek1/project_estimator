import 'package:project_estimator/models/paint_settings.dart';

class User {
  final String id;
  String avatar, name, company, address, phoneNumber, licenseNumber;
  PaintSettings paintSettings;

  User({
    this.id,
    this.avatar = "",
    this.name = "",
    this.company = "",
    this.address = "",
    this.phoneNumber = "",
    this.licenseNumber = "",
    PaintSettings paintSettings }) {
    this.paintSettings = paintSettings ?? PaintSettings();
  }

  User.fromUser(User user) :
    id = user.id,
    avatar = user.avatar,
    name = user.name,
    company = user.company,
    address = user.address,
    phoneNumber = user.phoneNumber,
    licenseNumber = user.licenseNumber,
    paintSettings = PaintSettings.fromMap(user.paintSettings.toMap());

  User.fromMap(Map<String, dynamic> map, String userId) :
    id = userId,
    avatar = map['avatar'],
    name = map['name'],
    company = map['company'],
    address = map['address'],
    phoneNumber = map['phoneNumber'],
    licenseNumber = map['licenseNumber'],
    paintSettings = PaintSettings.fromMap(map['paintSettings']);

  Map<String, dynamic> toMap() {
    return {
      'avatar': avatar,
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
      other.avatar == avatar &&
      other.name == name &&
      other.company == company &&
      other.address == address &&
      other.phoneNumber == phoneNumber &&
      other.licenseNumber == licenseNumber &&
      other.paintSettings == paintSettings;

  @override
  int get hashCode => id.hashCode^avatar.hashCode^name.hashCode^company.hashCode^address.hashCode^
                      phoneNumber.hashCode^licenseNumber.hashCode^paintSettings.hashCode;
}