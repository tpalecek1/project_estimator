class PaintSettings{
  double paintLow, paintMid, paintHigh, paintCoverage,
  laborRate, productionRate, doorCost, windowCost, accentWallCost, trim;

  //Default constructor, all attributes are optional named parameters with default values
  PaintSettings({
    this.paintLow = 15.0,
    this.paintMid = 25.0,
    this.paintHigh = 35.0,
    this.paintCoverage = 300,
    this.laborRate = 50.0,
    this.productionRate = 300,
    this.doorCost = 75,
    this.windowCost = 50,
    this.accentWallCost = 30,
    this.trim = 1.2
  });
  
  PaintSettings.fromMap(Map<dynamic, dynamic> map) :
    paintLow = map['paintLow'],
    paintMid = map['paintMid'],
    paintHigh = map['paintHigh'],
    paintCoverage = map['paintCoverage'],
    laborRate = map['laborRate'],
    productionRate = map['productionRate'],
    doorCost = map['doorCost'],
    windowCost = map['windowCost'],
    accentWallCost = map['accentWallCost'],
    trim = map['trim'];

  Map<String, dynamic> toMap() {
    return {
    'paintLow': paintLow,
    'paintMid': paintMid,
    'paintHigh': paintHigh,
    'paintCoverage': paintCoverage,
    'laborRate': laborRate,
    'productionRate': productionRate,
    'doorCost': doorCost,
    'windowCost': windowCost,
    'accentWallCost': accentWallCost,
    'trim': trim,
    };
  }


  @override
  bool operator==(Object other) =>
      other is PaintSettings &&
      other.paintLow == paintLow &&
      other.paintMid == paintMid &&
      other.paintHigh == paintHigh &&
      other.paintCoverage == paintCoverage &&
      other.laborRate == laborRate &&
      other.productionRate == productionRate &&
      other.doorCost == doorCost &&
      other.windowCost == windowCost &&
      other.accentWallCost == accentWallCost &&
      other.trim == trim;

  @override
  int get hashCode => paintLow.hashCode^paintMid.hashCode^paintHigh.hashCode^
                      paintCoverage.hashCode^laborRate.hashCode^productionRate.hashCode^
                      doorCost.hashCode^windowCost.hashCode^accentWallCost.hashCode^
                      trim.hashCode;
}