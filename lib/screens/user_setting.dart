import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_estimator/models/paint_settings.dart';
import 'package:project_estimator/models/user.dart';
import 'package:project_estimator/services/auth.dart';
import 'package:project_estimator/screens/signup_login.dart';
import 'package:project_estimator/services/dialog_manager.dart';
import 'package:project_estimator/services/permission_manager.dart';

String temp = 'https://firebasestorage.googleapis.com/v0/b/wasteagram-18a5f.appspot.com/o/2020-03-17%2005%3A24%3A38.249222?alt=media&token=514559cf-ad73-4692-8d22-7568a0f26089';
//todo: reduce duplicate code that upadte values throught firebase
class UserSetting extends StatefulWidget {

  static const routeName = 'user_setting';

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  final _auth = Auth();
  File image;

  void getImage(BuildContext context) async {
    if(await PermissionManager.checkAndRequestStoragePermissions()) { 
      DialogManager dialogManager = DialogManager(); 
      dialogManager.showProgressHud(context);         //progress hud I mentioned earlier, feel good
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
      //-----------FirebaseStorage code reference from CS492------------------//
      // StorageReference storageReference =
      // FirebaseStorage.instance.ref().child(DateTime.now().toString());
      // StorageUploadTask uploadTask = storageReference.putFile(image);
      // await uploadTask.onComplete;
      // final url = await storageReference.getDownloadURL();
      //----------------------------------------------------------------------//
      //---imitate backend process time for the image--------------------------//
      await Future.delayed(Duration(seconds: 1), () {
         dialogManager.closeProgressHud(); //pop out the progress hud
      });
      //-----------------------------------------------------------------------//
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    //get faked data
    User user = User(name: 'John Alpha', company: 'Big A', address: '1222 Pixley Pkwy, Lodi, CA 95240', phoneNumber: '4089514338', licenseNumber: 'A123456789');
    PaintSettings paintSettings = PaintSettings();

    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
        actions: [
          FlatButton(
            onPressed: (){
              showLogoutDialog(context);
            }, 
            child: Text('Logout', style: TextStyle(fontSize: 17.0, color: Colors.white))
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
                        backgroundColor: Colors.blue,
                        radius: 54.0,
                        child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50.0,
                            backgroundImage: image==null? NetworkImage(temp) : FileImage(image),
                          ),
                      ),
                    ),
                    Positioned(
                      bottom: 5,
                      right: 10,
                      child: IconButton(icon: Icon(Icons.photo), onPressed: (){
                        //choose a pic to save and put into image
                        getImage(context);
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

  void showLogoutDialog(BuildContext context) {
    showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text('Are you sure to logout?'),
        actions: [
          FlatButton(
            onPressed: (){
              Navigator.of(context).pop();
            }, 
            child: Text('cancel')
          ),  
          FlatButton(
            onPressed: (){
              logout(context);
              Navigator.of(context).pop();
            }, 
            child: Text('ok')
          ),        
        ],
      );  
    });
  }

  void logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => SignupLogin()), (_) => false
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

class SettingRow extends StatefulWidget {
  final String title;
  final String content;
  final Function(String) updateAction;
  SettingRow({Key key, @required this.title, @required this.content, @required this.updateAction}):super();

  @override
  _SettingRowState createState() => _SettingRowState();
}

class _SettingRowState extends State<SettingRow> {

  // Create a text controller and use it to retrieve the current value of the TextField.
  TextEditingController _myController;
  @override
  void initState() {
    _myController = TextEditingController(text: widget.content); //widget.content can not used before initstate()
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title, style: Theme.of(context).textTheme.subtitle),
        SizedBox(width: 5),
        Expanded(child: Container(alignment: Alignment.centerRight, child: Text(widget.content, textAlign: TextAlign.right))),
        SizedBox(width: 5),
        RaisedButton(onPressed: (){
          _showDialog(widget.title, widget.content);
        }, child: Text('change'))
      ],
    );
  }

  _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextFormField(
            controller: _myController,
            //initialValue: content,    //note: initialValue and controller can not be used at the same time
            decoration: InputDecoration(
              labelText: title, border: OutlineInputBorder()
            )
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
                  //print(_myController.text);  //test only
                widget.updateAction(_myController.text);
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


