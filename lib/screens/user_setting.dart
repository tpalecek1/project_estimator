import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_estimator/models/user.dart';
import 'package:project_estimator/services/auth.dart';
import 'package:project_estimator/screens/signup_login.dart';
import 'package:project_estimator/services/dialog_manager.dart';
import 'package:project_estimator/services/permission_manager.dart';
import 'package:project_estimator/services/database.dart';
import 'package:project_estimator/services/storage.dart';

class UserSetting extends StatefulWidget {
  UserSetting({Key key, this.userId}) : super(key: key);
  static const routeName = 'user_setting';
  final String userId;

  @override
  _UserSettingState createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  File image;

  User _user;
  User _userState;
  StreamSubscription<User> _userStreamSubscription;

  void getImage(BuildContext context) async {
    if(await PermissionManager.checkAndRequestStoragePermissions()) {
      DialogManager dialogManager = DialogManager(); 
      dialogManager.showProgressHud(context);         //progress hud I mentioned earlier, feel good

      image = await ImagePicker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        if (_user.avatar != '') {
          await Storage().deleteAvatar(_user.avatar);
        }
        _user.avatar = await Storage().uploadAvatar(image);
        await Database().updateUser(_user);
      }

      dialogManager.closeProgressHud(); //pop out the progress hud
    }
  }

  @override
  void initState() {
    super.initState();

    _listenForUser();
  }

  @override
  Widget build(BuildContext context) {
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
        body: _user == null ?
        Center(child: CircularProgressIndicator()) :
        SingleChildScrollView(
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
                                backgroundImage: _user.avatar==''? AssetImage('assets/images/avatar.png') : NetworkImage(_user.avatar),
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
                        child: PersonInfo(user: _user, userState: _userState)
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
                        child: PaintSettingBox(user: _user, userState: _userState)
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Delete Account', style: Theme.of(context).textTheme.title),
                  Container(
                    width: double.infinity,
                    child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.red, width: 3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.fromLTRB(0, 4, 0, 4),
                        child: DeleteAccountBox()
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
    await Auth().signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => SignupLogin()), (_) => false
    );   
  }

  void _listenForUser() {
    _userStreamSubscription = Database().readUserRealTime(widget.userId).listen((user) {
      setState(() { _user = user; _userState = User.fromUser(user); });
    });
  }

  @override
  void dispose() {
    _userStreamSubscription.cancel();
    super.dispose();
  }
}

class PersonInfo extends StatefulWidget {
  final User user;
  final User userState;
  PersonInfo({Key key, @required this.user, @required this.userState}):super(key: key);

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
            widget.user.name = value;
            if (widget.user != widget.userState) {
              Database().updateUser(widget.user);
            }
          }),
          Divider(),
          SettingRow(title: "Company", content: widget.user.company, updateAction: (value){
            widget.user.company = value;
            if (widget.user != widget.userState) {
              Database().updateUser(widget.user);
            }
          }),
          Divider(),
          SettingRow(title: "Address", content: widget.user.address, updateAction: (value){
            widget.user.address = value;
            if (widget.user != widget.userState) {
              Database().updateUser(widget.user);
            }
          }),
          Divider(),
          SettingRow(title: "Phone Number", content: widget.user.phoneNumber, updateAction: (value){
            widget.user.phoneNumber = value;
            if (widget.user != widget.userState) {
              Database().updateUser(widget.user);
            }
          }),
          Divider(),
          SettingRow(title: "License number", content: widget.user.licenseNumber, updateAction: (value){
            widget.user.licenseNumber = value;
            if (widget.user != widget.userState) {
              Database().updateUser(widget.user);
            }
          }),
        ],
      ),
    );
  }
}

class PaintSettingBox extends StatefulWidget {
  final User user;
  final User userState;
  PaintSettingBox({Key key, @required this.user, @required this.userState}) : super(key: key);

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
          SettingRow(title: "PaintLow (\$/gallon)", content: '${widget.user.paintSettings.paintLow}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.paintLow = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
          }),
          Divider(),
          SettingRow(title: "PaintMid (\$/gallon)", content: '${widget.user.paintSettings.paintMid}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.paintMid = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
          }),
          Divider(),
          SettingRow(title: "PaintHigh (\$/gallon)", content: '${widget.user.paintSettings.paintHigh}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.paintHigh = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
          }),
          Divider(),
          SettingRow(title: "PaintCoverage (sqft/gallon)", content: '${widget.user.paintSettings.paintCoverage}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.paintCoverage = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
          }),
          Divider(),
          SettingRow(title: "ProductionRate (sqft/hour)", content: '${widget.user.paintSettings.productionRate}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.productionRate = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
          }),
          Divider(),
          SettingRow(title: "LaborRate (\$/hour)", content: '${widget.user.paintSettings.laborRate}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.laborRate = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
          }),
          Divider(),
          SettingRow(title: "DoorCost (\$)", content: '${widget.user.paintSettings.doorCost}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.doorCost = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
          }),
          Divider(),
          SettingRow(title: "WindowCost(\$)", content: '${widget.user.paintSettings.windowCost}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.windowCost = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
          }),
          Divider(),
          SettingRow(title: "AccentWallCost (\$)", content: '${widget.user.paintSettings.accentWallCost}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.accentWallCost = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
          }),
          Divider(),
          SettingRow(title: "Trim (\$/linear ft)", content: '${widget.user.paintSettings.trim}', updateAction: (value){
            if (double.tryParse(value) != null) {
              widget.user.paintSettings.trim = double.parse(value);
              if (widget.user != widget.userState) {
                Database().updateUser(widget.user);
              }
            }
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
  TextEditingController _myController = TextEditingController();

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
        _myController.text = content;
        return AlertDialog(
          content: TextFormField(
            controller: _myController,
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

class DeleteAccountBox extends StatefulWidget {
  @override
  _DeleteAccountBoxState createState() => _DeleteAccountBoxState();
}

class _DeleteAccountBoxState extends State<DeleteAccountBox> {

  TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(child: Text('Once you delete this account, there is no going back.', style: Theme.of(context).textTheme.subtitle)),
          SizedBox(width: 5),
          RaisedButton(onPressed: (){
            showDialog(
              context: context,
              builder: (newContext) { //different from what have learned from CS492, the context generated from dialog builder has no scaffold context
                _textController.text = '';
                return AlertDialog(
                  contentPadding : const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                  title:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    Text('Are you sure?\n', style: TextStyle(fontSize: 18, color: Colors.black)),
                    Text('Please enter your password to confirm\n', style: TextStyle(fontSize: 16, color: Colors.black))
                  ]),
                  content: TextFormField(
                    obscureText: true,
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()
                    )
                  ),
                  actions: [
                    FlatButton(
                      onPressed: (){
                        Navigator.of(newContext).pop();
                      }, 
                      child: Text('Cancel')
                    ),  
                    FlatButton(
                      onPressed: () async {
                        Navigator.of(newContext).pop();
                        if (_textController.text.length < 6) {
                          showSnackBar(context, 'Invalid password. Please try again.');
                        }
                        else {
                          DialogManager dialogManager = DialogManager();
                          dialogManager.showProgressHud(context);
                          try {
                            await Auth().deleteAccount(_textController.text);
                            dialogManager.closeProgressHud();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (ctx) => SignupLogin()), (_) => false
                            );
                          }
                          catch (errorMsg) {
                            dialogManager.closeProgressHud();
                            showSnackBar(context, errorMsg); //do not use newContext whe calling the snackbar
                          }
                        }
                      }, 
                      child: Text('Confirm')
                    ),
                  ],
                );
              }
            );
          }, child: Text('delete'))
        ],
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        backgroundColor: Colors.redAccent.withOpacity(0.9),
        elevation: 1000,
        behavior: SnackBarBehavior.floating
      )
    );   
  }
}