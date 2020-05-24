import 'dart:io';
import 'package:project_estimator/screens/project_estimate.dart';
import 'download_pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfPreview extends StatelessWidget {
  const PdfPreview({Key key, this.path, this.pdf}) : super(key: key);
  
  final String path;
  final pw.Document pdf;

  @override
  Widget build(BuildContext context) {
    print(path);
    return 
        Stack(
          children: [
            PDFViewerScaffold(
              path: path,
              appBar: AppBar(
              actions: <Widget>[
                FlatButton(
                  child: Icon(Icons.mail_outline),
                  onPressed: (){
                    //open email app with prefilled info
                  },
                ),
                FlatButton(
                  child: Icon(Icons.file_download),
                  onPressed: ()async{
                    //Save to downloads folder
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DownloadPdf(pdf: pdf)));
                  },
                ),
              ],
            ),
            ),
          ]
        );
  }
}