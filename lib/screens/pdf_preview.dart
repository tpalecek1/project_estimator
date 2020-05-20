import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfPreview extends StatelessWidget {
  const PdfPreview({Key key, this.path}) : super(key: key);
  
  final String path;


  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      path: path,
    );
  }
}