import 'package:intl/intl.dart';

class Project {
  String name, status, description, clientName, clientAddress, clientPhoneNumber;
  DateTime date;

  Project({
    this.name = "",
    this.status = "not bid",
    this.description = "",
    this.clientName = "",
    this.clientAddress = "",
    this.clientPhoneNumber = "",
    this.date,
  });

  Project.fromMap(dynamic map){
    name = map['name'];
    status = map["status"];
    description = map["description"];
    clientName = map['clientName'];
    clientAddress = map['clientAddress'];
    clientPhoneNumber = map['clientPhoneNumber'];
    date = map['date'];
  }

  //Returns the date as a formatted string
  String dateString(){
    return DateFormat('yyyy-MM-dd').format(date);
  }

}