class User {
  String name, company, address, phoneNumber, licenseNumber;
  int id;

  User({
    this.id,
    this.name = "",
    this.company = "",
    this.address = "",
    this.phoneNumber = "",
    this.licenseNumber = "",
  });

  User.fromMap(dynamic map){
    id = map['id'];
    name = map['name'];
    company = map['company'];
    address = map['address'];
    phoneNumber = map['phoneNumber'];
    licenseNumber = map['licenseNumber'];
  }
}