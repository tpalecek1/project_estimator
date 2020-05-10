class Estimate {
  String id;
  List<Item> items;
  Estimate({ List<Item> items }) {
    this.items = items ?? List<Item>();
  }

  Estimate.fromMap(Map<String, dynamic> map, String estimateId){
    items = itemsFromString(map['items']);
  }


  Map<String, dynamic> toMap() {
    return {
      'name': 'a',
      'items': itemsToString(),
    };
  }

  Estimate.fromString(String string) {
    items = itemsFromString(string);
  }

  void addItem(String name, double cost) {
    items.add(Item(name: name, cost: cost));
  }

  void removeItem(Item item) {
    items.remove(item);
  }

  double subtotal(){
    double subtotal = 0;
    for(Item item in this.items){
      if(item.cost != null){
       subtotal += item.cost;
      }
    }
    return subtotal;
  }

  // method that transforms a backtick separated string of values into items for
  // this estimate
  List<Item> itemsFromString(String string) {
    List<String> values = string.split('`');
    List<Item> items = List<Item>();

    while (values.length > 1) {
      String name = values.removeAt(0);
      String cost = values.removeAt(0);

      items.add(Item(name: name, cost: double.parse(cost)));
    }

    return items;
  }

  // method that transforms items of this estimate into a backtick separated
  // string of values
  String itemsToString() {
    String values = '';

    items.forEach((item) {
      values += item.name.replaceAll(RegExp('`'), "'") + '`' + item.cost.toString() + '`';
    });

    return values.length > 0 ? values.substring(0, values.length - 1) : values;
  }

  @override
  bool operator==(Object other) =>
      other is Estimate &&
      other.itemsToString() == itemsToString();

  @override
  int get hashCode => itemsToString().hashCode;
}

class Item {
  String name;
  double cost;

  Item({ this.name = '', this.cost = 0.0 });


  @override
  bool operator==(Object other) =>
      other is Item &&
      other.name == name &&
      other.cost == cost;

  @override
  int get hashCode => name.hashCode^cost.hashCode;
}