import 'package:flutter/material.dart';
import 'dart:io';
import '../models/estimate.dart';
import '../models/project.dart';
import '../models/room.dart';
import '../models/room_note.dart';
import '../models/project_note.dart';
import '../models/user.dart';
import '../models/paint_settings.dart';
import 'package:project_estimator/services/database.dart';
import 'pdf_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ProjectEstimate extends StatefulWidget {
  ProjectEstimate({Key key, this.userId, this.project, this.rooms}) : super(key: key);
  static const routeName = 'project_estimate';
  final String userId;
  final Project project;
  final List<Room> rooms;

  @override
  _ProjectEstimateState createState() => _ProjectEstimateState();
}

class _ProjectEstimateState extends State<ProjectEstimate> {
  final formKey = GlobalKey<FormState>();
  Project project;
  List<Room> rooms;
  Estimate estimate;

  List<ProjectNote> projectNotes;
  List<RoomInfo> roomNotes;   // [ RoomInfo(name: 'room name', notes: List<RoomNote>), ... ]
  PaintSettings settings;

  bool _isProcessing = false;
  
  final pdf = pw.Document();
  String filePath;


  @override
  void initState() {
    super.initState();

    project = widget.project;
    rooms = widget.rooms;
    estimate = project.estimate;

    if (estimate == null) {
      generateEstimate();
    }
    else if(estimate.items.length == 0){ //Temporary... ask user if they want to generate an estimate
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Project Estimate is empty'),
                content: Text('Would you like to generate one?'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      generateEstimate();
                    },
                  )
                ],
              );
            }
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (estimate == null || _isProcessing) {
      return Scaffold(
        appBar: AppBar(
            title: Text('Project Estimate')
        ),
        body: Center(
            child: CircularProgressIndicator()
        )
      );
    }
    else {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              title: Text('Project Estimate')
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                project.estimate = estimate;
                Database().updateProject(project);
              }
          ),
          endDrawer: Drawer(
              child: ListView(
                children:[
                  ListTile(
                      leading: Icon(Icons.restore), title: Text("Restore to default", style: Theme.of(context).textTheme.subtitle, textScaleFactor: 1.1,),
                      onTap: () {
                        showDialog(context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                title: Text("Are you sure you wish to restore the estimate to default?"),
                                content: Text("All changes will be discarded."),
                                actions: [
                                  FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: Text("Accept"),
                                    onPressed: (){
                                      Navigator.of(context).pop();  // close AlertDialog
                                      Navigator.of(context).pop();  // close Drawer
                                      generateEstimate();
                                    },
                                  ),
                                ],
                              );
                            }
                        );
                      }
                  ),
                  ListTile(
                    leading: Icon(Icons.view_compact), 
                    title: Text("Download as PDF", style: Theme.of(context).textTheme.subtitle, textScaleFactor: 1.1,),
                    onTap: () {
                      writePdf();
                      savePdf();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfPreview(path: filePath)));
                    },
                  ),
                  ListTile(leading: Icon(Icons.email), title: Text("Send as email", style: Theme.of(context).textTheme.subtitle, textScaleFactor: 1.1,)),
                ],
              )
          ),
          body: Form(
              key: formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 10,),
                    Text(
                      'Project: ${project.name}',
                      style: Theme.of(context).textTheme.title,
                      textAlign: TextAlign.left,
                    ),
                    Divider(color: Colors.black38, thickness: 1, endIndent: 50, height: 20),
                    Text(
                      'Scope of work',
                      style: Theme.of(context).textTheme.title,
                      textAlign: TextAlign.left,
                    ),
                    Flexible(
                      flex: 5,
                      child: ListView.builder(
                        itemCount: estimate.items.length+1,
                        itemBuilder: (context, index){
                          if(index == estimate.items.length){
                            return Container(height: 40, width: 50,
                                child: SizedBox(width: 50,
                                    child: FlatButton(
                                      child: Text("Add Scope Item"),
                                      onPressed: (){
                                        estimate.addItem("New Item", 0);
                                        setState((){});
                                      },
                                    )
                                )
                            );
                          }
                          return ListTile(
                              key: ObjectKey(estimate.items[index]),
                              title: Row(
                                children: <Widget>[
                                  ButtonTheme(
                                    padding: EdgeInsets.only(right: 5),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minWidth: 0,
                                    height: 0,
                                    child: FlatButton(
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      child: Icon(Icons.delete_forever),
                                      onPressed: (){
                                        estimate.removeItem(estimate.items[index]);
                                        setState(() { });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      maxLines: 3,
                                      minLines: 1,
                                      initialValue: estimate.items[index].name,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                  width: 90,
                                  child: Row(
                                    children: [
                                      Text("\$ "),
                                      Expanded(
                                        child: TextFormField(
                                          initialValue: estimate.items[index].cost.toString(),
                                          onChanged: (value){
                                            estimate.items[index].cost = double.tryParse(value);
                                            setState(() {});
                                          },
                                          keyboardType: TextInputType.numberWithOptions(),
                                        ),
                                      ),
                                    ],
                                  )
                              )
                          );
                        },
                      ),
                    ),
                    Flexible(flex: 3,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * .7,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Subtotal:',
                                      style: Theme.of(context).textTheme.title,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      '\$ ' + estimate.subtotal().toString(),
                                      style: Theme.of(context).textTheme.title,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tax:',
                                      style: Theme.of(context).textTheme.title,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      (estimate.subtotal() * 0.0725).toStringAsFixed(2),
                                      style: Theme.of(context).textTheme.title,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                Divider(height: 40, color: Colors.black),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total:',
                                      style: Theme.of(context).textTheme.title,
                                      textAlign: TextAlign.left,
                                    ),
                                    Text(
                                      (estimate.subtotal() * 0.0725 + estimate.subtotal()).toStringAsFixed(2),
                                      style: Theme.of(context).textTheme.title,
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                  ]
              )
          )
      );
    }
  }

  void calculateCosts(){
    double doors = 0; 
    double windows = 0; 
    double accents = 0;
    double ceilings = 0.0;
    double walls = 0.0;
    double base = 0.0;
    double chair = 0.0;
    double crown = 0.0;

    for(Room room in rooms){
      double length = room.length;
      double width = room.width;
      doors = doors+room.doorCount;
      windows += room.windowCount;
      accents += room.accentWallCount;
      ceilings += length * width;
      walls += (length * 2 + width * 2) * room.ceilingHeight;
      if(room.hasBaseboard){
        base += (length + width) * 2;
      }
      if(room.hasChairRail){
        chair += (length + width) * 2;
      }
      if(room.hasBaseboard){
        crown += (length + width) * 2;
      }
    }
    
    estimate.addItem('Painting walls', (walls / settings.paintCoverage) * settings.paintMid + (walls / settings.productionRate) * settings.laborRate);
    estimate.addItem('Painting ceilings', (ceilings / settings.paintCoverage) * settings.paintMid + (ceilings / settings.productionRate) * settings.laborRate);
    estimate.addItem('Painting doors', doors * settings.doorCost);
    estimate.addItem('Painting window trim', windows * settings.windowCost);
    estimate.addItem('Painting accent walls', accents * settings.accentWallCost);
    estimate.addItem('Painting trim', num.parse(((base+chair+crown) * settings.trim).toStringAsFixed(2)));

  }

  void generateEstimate() async {
    setState(() { _isProcessing = true; });

    // get project and room notes
    // note:
    //    -only need to get them once during the lifecycle of ProjectEstimate screen
    //    -and getting them here because there's no need to get them if generateEstimate()
    //    is never called (i.e. user only uses the saved estimate)
    if (projectNotes == null || roomNotes == null) {    // only get notes once

      projectNotes = await Database().readProjectNotesWithCost(project.id);
      projectNotes.sort((a, b) => (a.description).compareTo(b.description));

      roomNotes = List<RoomInfo>();
      await Future.forEach(rooms, (room) async {
        List<RoomNote> _roomNotes = await Database().readRoomNotesWithCost(room.id);
        _roomNotes.sort((a, b) => (a.description).compareTo(b.description));
        roomNotes.add(RoomInfo(name: room.name, notes: _roomNotes));
      });
    }

    // get user paint settings
    // note: same logic as project and room notes above
    if (settings == null) {                             // only get settings once
      User user = await Database().readUser(widget.userId);
      settings = user.paintSettings;
    }

    estimate = Estimate();

    calculateCosts();

    for(ProjectNote projectNote in projectNotes){
      estimate.addItem(projectNote.description, 0);
    }
    for(RoomInfo room in roomNotes){
      for(RoomNote roomNote in room.notes){
        estimate.addItem(room.name + ": " + roomNote.description, 0);
      }
    }

    setState(() { _isProcessing = false; });
  }
  
  void writePdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      header: (pw.Context context){
        return pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Paragraph(text: "License # #####"),
                pw.Paragraph(text: 'Page No. # of #')
              ],
            ),
            pw.Align(
              alignment: pw.Alignment.topLeft,
              child: pw.Paragraph(text: 'Expires: xx', textAlign: pw.TextAlign.left)
            )
          ],
        );
      },
      footer: (pw.Context context){
        return pw.Align(alignment: pw.Alignment.bottomCenter,
            child: pw.Container(
              padding: pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.BoxBorder(
                  top: true,
                  bottom: true,
                  left: true,
                  right: true,
                  color: PdfColor.fromRYB(1, 1, 1),
                  width: 2,
                )
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Paragraph(text: 'We propose hereby to furnish material and labor for the above scope of work -\n in accordance with the above specifications for the sum of \$${(estimate.subtotal() * 1.0725).toStringAsFixed(2)} '),
                  pw.Paragraph(text: 'Any alteration or deviation from the above specifications involving extra costs will be executed only upon written order, and will become an extra charge over and above the estimate. All agreements contingent upon strikes, accidents or delays beyond control. Owner to carry fire, tornado and other necessary insurance upon above work.  Workmen\'s Compensation and public Liability Insurance on above work to be taken out by contractor. Payment in full is due within 30 days of completion of above work.'),
                  pw.Row(
                    children: [
                      pw.Container(
                        width: 50,
                        child: pw.Paragraph(text: 'Authorized Signature'),
                      ),
                      pw.Expanded(
                        child: pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.BoxBorder(
                              bottom: true,
                              width: 1.5,
                            )
                          ),
                          height: 20,
                          child: pw.Container(),
                        ),
                      )
                    ]
                  )

                ]
              )
            ),
          );
      },
      build: (pw.Context context) {
        return [
          pw.Header(
            level: 0,
            child: pw.Align(
              alignment: pw.Alignment.center,
              child: pw.Text('Proposal', style: pw.TextStyle(fontSize: 36)),
            ),
          ),
          pw.Table(

            border: pw.TableBorder(),
            children: [
              pw.TableRow(
                children: [
                  pw.Paragraph(text: 'Submitted to', padding: pw.EdgeInsets.only(left: 3)),
                  pw.Paragraph(text: 'Today\'s date', padding: pw.EdgeInsets.only(left: 3)), 
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Paragraph(text: 'Phone Number', padding: pw.EdgeInsets.only(left: 3)),
                  pw.Paragraph(text: 'Job Name', padding: pw.EdgeInsets.only(left: 3)), 
                ],
              ),
              pw.TableRow(
                children: [
                  pw.Paragraph(text: 'Project address', padding: pw.EdgeInsets.only(left: 3)),
                  pw.Paragraph(text: 'Project Name', padding: pw.EdgeInsets.only(left: 3)), 
                ],
              ),
            ],
          ),
          pw.Align(
            alignment: pw.Alignment.topLeft,
            child: pw.Paragraph(text: 'We propose hereby to furnish material and labor necessary for the completion of:')
          ),
          pw.Align(
            alignment: pw.Alignment.topLeft,
            child: pw.ListView.builder(
              itemCount: estimate.items.length,
              itemBuilder: (context, index){
                  return pw.Row(
                    children: [
                      pw.Flexible(
                        child:pw.Bullet(text: '${estimate.items[index].name}'),
                      ),
                      pw.Flexible(
                        child: pw.Paragraph(text: '\$${estimate.items[index].cost}'),
                        
                      ),
                    ]
                  );
              },
            ),
          ),
        ];
      },
    ));
  }

  Future savePdf() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String documentPath = docDir.path;
    filePath = "$documentPath/example1.pdf";
    File file = File(filePath);

    file.writeAsBytesSync(pdf.save());
  }
}

class RoomInfo {
  String name;
  List<RoomNote> notes;

  RoomInfo({ this.name, this.notes });
}

