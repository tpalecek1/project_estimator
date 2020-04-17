class Estimate {
  String name, details;

  Estimate({
    this.name = "Estimate",
    this.details = "" 
  });

  Estimate.fromMap(dynamic map){
    name = map['name'];
    details = map['details'];
  }
}