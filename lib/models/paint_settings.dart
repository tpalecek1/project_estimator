class PaintSettings{
  double paintLow, paintMid, paintHigh, paintCoverage,
  laborRate, doorCost, windowCost, accentCost, trim;
  Map paintSettings;

  //Default constructor, all attributes are optional named parameters with default values
  PaintSettings({
    this.paintLow = 15.0,
    this.paintMid = 25.0,
    this.paintHigh = 35.0,
    this.paintCoverage = 300,
    this.laborRate = 50.0,
    this.doorCost = 75,
    this.windowCost = 50,}
  );
  
  PaintSettings.fromMap(dynamic map){
    paintLow = map['paintLow'];
    paintMid = map['paintMid'];
    paintHigh = map['paintHigh'];
    paintCoverage = map['paintCoverage'];
    laborRate = map['laborRate'];
    doorCost = map['doorCost'];
    windowCost = map['windowCost'];
  }

}