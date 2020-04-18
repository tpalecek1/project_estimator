class User {
  String name, company, address, phoneNumber, licenseNumber;

  User({
    this.name = "",
    this.company = "",
    this.address = "",
    this.phoneNumber = "",
    this.licenseNumber = "",
  });

  User.fromMap(dynamic map){
    name = map['name'];
    company = map['company'];
    address = map['address'];
    phoneNumber = map['phoneNumber'];
    licenseNumber = map['licenseNumber'];
  }
}