
import 'package:flutter/material.dart';

class DialogManager {
  BuildContext _progressHudContext;

  showProgressHud(BuildContext dialogContext) {
    showDialog( 
      context: dialogContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        _progressHudContext = context;
        return WillPopScope(
          onWillPop: () async => false,   // disable Android system "back" button
          child: Center(child: CircularProgressIndicator()),
        );
    });
  }

  closeProgressHud() {
    if(_progressHudContext != null) {
      Navigator.of(_progressHudContext).pop();
      _progressHudContext = null;
    }
  }
}