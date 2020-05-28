import 'package:flutter/material.dart';
import 'dart:io';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class DownloadPdf extends StatelessWidget {
  const DownloadPdf({Key key, this.pdf}) : super(key: key);
  static const routeName = 'download_pdf';
  final pw.Document pdf;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String fileName;
    return Scaffold(
      appBar: AppBar(
        title: Text('Save as PDF')
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          if(formKey.currentState.validate()){
            formKey.currentState.save();
            Directory downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
            String downloadFilePath = '${downloadsDirectory.path}/$fileName.pdf';
            File file = File(downloadFilePath);
            file.writeAsBytesSync(pdf.save());
            Navigator.of(context).pop(Navigator.of(context).pop());
          }
        }),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child:
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Please enter a file name',
                  style: Theme.of(context).textTheme.headline5
                ),
                TextFormField(
                  autovalidate: false,
                  textAlign: TextAlign.left,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'File Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  onSaved: (name){
                    fileName = name;
                  },
                  validator: (name){
                    if(name.trim().length == 0){
                      return 'File name can\'t be empty';
                    }
                    else if(name.contains(RegExp('[^a-zA-Z0-9]'))){
                      return 'File name can\'t contain special characters';
                    }
                    else{
                      return null;
                    }
                  } 
                ),
              ]
            ),
          ),
        ),
      )
    );
  }
}