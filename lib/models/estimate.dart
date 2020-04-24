class Estimate {
  int id;
  String name, details;
  List<Map<String, double>> items;

  Estimate({this.name = "Estimate", this.details = "", this.id}){
      items = List<Map<String, double>>();
  }

  Estimate.fromMap(dynamic map, List<Map<String, double>> items){
    id = map['id'];
    name = map['name'];
    details = map['details'];
    this.items.addAll(items);
  }
}