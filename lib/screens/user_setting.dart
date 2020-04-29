import 'package:flutter/material.dart';
import 'package:project_estimator/models/paint_settings.dart';
import 'package:project_estimator/models/user.dart';
import 'package:project_estimator/services/auth.dart';
import 'package:project_estimator/screens/signup_login.dart';

String temp = 'https://firebasestorage.googleapis.com/v0/b/wasteagram-18a5f.appspot.com/o/2020-03-17%2005%3A24%3A38.249222?alt=media&token=514559cf-ad73-4692-8d22-7568a0f26089';
//todo: reduce duplicate code
class UserSetting extends StatelessWidget {

  static const routeName = 'user_setting';
  final _auth = Auth();

  @override
  Widget build(BuildContext context) {
    //get faked data
    User user = User(name: 'John Alpha', company: 'Big A', address: '1222 Pixley Pkwy, Lodi, CA 95240', phoneNumber: '4089514338', licenseNumber: 'A123456789');
    PaintSettings paintSettings = PaintSettings();
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (ctx) => SignupLogin()), (_) => false
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                child: Stack(
                  children: [
                    Center(
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50.0,
                          backgroundImage: NetworkImage(temp),
                        ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 10,
                      child: IconButton(icon: Icon(Icons.photo), onPressed: (){
                        //todo
                      })
                    )
                  ]
                ), constraints: BoxConstraints.expand(height: 150),
              ),
              Text('Personal Information', style: Theme.of(context).textTheme.title),
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blueAccent, width: 3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 4, 0, 4), 
                  child: PersonInfo(user: user) 
                ),
              ),
              SizedBox(height: 20),
              Text('Paint Settings', style: Theme.of(context).textTheme.title),
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blueAccent, width: 3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  margin: EdgeInsets.fromLTRB(0, 4, 0, 4), 
                  child: PaintSettingBox(paintSettings: paintSettings) 
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}

class PersonInfo extends StatefulWidget {
  final User user;
  PersonInfo({Key key, @required this.user}):super(key: key);

  @override
  _PersonInfoState createState() => _PersonInfoState();
}

class _PersonInfoState extends State<PersonInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SettingRow(title: "Name", content: widget.user.name, updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "Company", content: widget.user.company, updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "Address", content: widget.user.address, updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "Phone Number", content: widget.user.phoneNumber, updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "License number", content: widget.user.licenseNumber, updateAction: (value){
            //todo: define update action
          }),
        ],
      ),
    );
  }
  //-------------delete this segment after week 8 implement-------------------------//
  // Widget getPersonInfoRow({@required String title, @required String content}) {
  //   return Row(
  //     children: [
  //       Text(title, style: Theme.of(context).textTheme.subtitle),
  //       SizedBox(width: 5),
  //       Expanded(child: Container(alignment: Alignment.centerRight, child: Text(content, textAlign: TextAlign.right))),
  //       SizedBox(width: 5),
  //       RaisedButton(onPressed: (){
  //         _showDialog(title, content);
  //       }, child: Text('change'))
  //     ],
  //   );
  // }
  // _showDialog(String title, String content) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         content: TextFormField(
  //           initialValue: content,
  //           decoration: InputDecoration(
  //             labelText: title, border: OutlineInputBorder()
  //           ),
  //           onSaved: (value) {
  //             //todo
  //           },
  //         ),
  //         actions: [
  //           FlatButton(
  //             onPressed: (){
  //               Navigator.of(context).pop();
  //             }, 
  //             child: Text('Cancel')
  //           ),  
  //           FlatButton(
  //             onPressed: (){
  //               //todo: update the data
  //               Navigator.of(context).pop();
  //             }, 
  //             child: Text('Update')
  //           ),     
  //         ],
  //       );
  //     }
  //   );
  // }
}

class PaintSettingBox extends StatefulWidget {
  final PaintSettings paintSettings;
  PaintSettingBox({Key key, @required this.paintSettings}):super(key: key);

  @override
  _PaintSettingBoxState createState() => _PaintSettingBoxState();
}

class _PaintSettingBoxState extends State<PaintSettingBox> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SettingRow(title: "PaintLow (\$/gallon)", content: '${widget.paintSettings.paintLow}', updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "PaintMid (\$/gallon)", content: '${widget.paintSettings.paintMid}', updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "PaintHigh (\$/gallon)", content: '${widget.paintSettings.paintHigh}', updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "PaintCoverage (sqft/gallon)", content: '${widget.paintSettings.paintCoverage}', updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "ProductionRate (\$/hour)", content: '${widget.paintSettings.productionRate}', updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "LaborRate (sqft/hour)", content: '${widget.paintSettings.laborRate}', updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "DoorCost (\$)", content: '${widget.paintSettings.doorCost}', updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "WindowCost(\$)", content: '${widget.paintSettings.windowCost}', updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "AccentWallCost (\$)", content: '${widget.paintSettings.accentWallCost}', updateAction: (value){
            //todo: define update action
          }),
          Divider(),
          SettingRow(title: "Trim (\$/linear ft)", content: '${widget.paintSettings.trim}', updateAction: (value){
            //todo: define update action
          }),
        ],
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  final String title;
  final String content;
  final Function(String) updateAction;
  SettingRow({Key key, @required this.title, @required this.content, @required this.updateAction}):super();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: Theme.of(context).textTheme.subtitle),
        SizedBox(width: 5),
        Expanded(child: Container(alignment: Alignment.centerRight, child: Text(content, textAlign: TextAlign.right))),
        SizedBox(width: 5),
        RaisedButton(onPressed: (){
          _showDialog(context, title, content);
        }, child: Text('change'))
      ],
    );
  }
  _showDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        String updateValue; //temp, will adjust on week 8
        return AlertDialog(
          content: TextFormField(
            initialValue: content,
            decoration: InputDecoration(
              labelText: title, border: OutlineInputBorder()
            ),
            onSaved: (value) {
              //todo: save the value
              updateValue = value;
            },
          ),
          actions: [
            FlatButton(
              onPressed: (){
                Navigator.of(context).pop();
              }, 
              child: Text('Cancel')
            ),  
            FlatButton(
              onPressed: (){
                //todo upate the data
                updateAction(updateValue);
                Navigator.of(context).pop();
              }, 
              child: Text('Update')
            ),
          
          ],
        );
      }
    );
  }
}


