import 'package:flutter/material.dart';

class NewNoteDialog extends StatefulWidget {
  NewNoteDialog({this.title, this.hint, this.onCancel, this.onSubmit});

  String title;
  String hint;
  Function onCancel;
  Function onSubmit;

  @override
  _NewNoteDialogState createState() => _NewNoteDialogState();
}

class _NewNoteDialogState extends State<NewNoteDialog> {
  bool checkboxValue;
  String title;
  String hint;
  Function onCancel;
  Function onSubmit;

  @override
  void initState() {
    checkboxValue = false;
    title = widget.title;
    hint = widget.hint;
    onCancel = widget.onCancel;
    onSubmit = widget.onSubmit;
    super.initState();
  }


  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        Text('Has Cost'),
        Checkbox(
          value: checkboxValue,
          onChanged: (value){
            setState(() {
              checkboxValue = value;
            });
          },
        ),
        FlatButton(
          child: Text('Cancel'),
          onPressed: onCancel,
        ),
        RaisedButton(
          child: Text('Submit'),
          //todo - add note to database
          onPressed: (){
            String note = _textEditingController.text;
            onSubmit(checkboxValue, note);
          }
        ),
      ],
    );
  }
}