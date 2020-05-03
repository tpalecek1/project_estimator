import 'package:intl/intl.dart';

class Project {
  final String id;
  String name, status, description, clientName, clientAddress, clientPhoneNumber;
  DateTime date;

  Project({
    this.id,
    this.name = "",
    this.status = "not bid",
    this.description = "",
    this.clientName = "",
    this.clientAddress = "",
    this.clientPhoneNumber = "",
    DateTime date }) {
    this.date = date ?? DateTime.now();
  }

  Project.fromMap(Map<String, dynamic> map, String projectId) :
    id = projectId,
    name = map['name'],
    status = map["status"],
    description = map["description"],
    clientName = map['clientName'],
    clientAddress = map['clientAddress'],
    clientPhoneNumber = map['clientPhoneNumber'],
    date = DateTime.parse(map['date']);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'status': status,
      'description': description,
      'clientName': clientName,
      'clientAddress': clientAddress,
      'clientPhoneNumber': clientPhoneNumber,
      'date': dateString(),
    };
  }

  //Returns the date as a formatted string
  String dateString(){
    return DateFormat('yyyy-MM-dd').format(date);
  }


  @override
  bool operator==(Object other) =>
      other is Project &&
      /*other.id == id &&*/
      other.name == name &&
      other.status == status &&
      other.description == description &&
      other.clientName == clientName &&
      other.clientAddress == clientAddress &&
      other.clientPhoneNumber == clientPhoneNumber &&
      other.dateString() == dateString();

  @override
  int get hashCode => /*id.hashCode^*/name.hashCode^status.hashCode^description.hashCode^
                      clientName.hashCode^clientAddress.hashCode^clientPhoneNumber.hashCode^
                      dateString().hashCode;
}