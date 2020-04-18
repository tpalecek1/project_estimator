class Estimate {
  String name, details;
  List<Map<String, double>> items;

  Estimate({this.name = "Estimate", this.details = "" }){
      items = List<Map<String, double>>();
  }

  Estimate.fromMap(dynamic map, List<Map<String, double>> items){
    name = map['name'];
    details = map['details'];
    this.items.addAll(items);
  }
}