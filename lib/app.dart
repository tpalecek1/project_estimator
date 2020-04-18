import 'package:flutter/material.dart';
import 'package:project_estimator/screens/edit_project.dart';
import 'package:project_estimator/screens/edit_room.dart';
import 'package:project_estimator/screens/project_detail.dart';
import 'package:project_estimator/screens/project_estimate.dart';
import 'package:project_estimator/screens/project_notes.dart';
import 'package:project_estimator/screens/room_detail.dart';
import 'package:project_estimator/screens/room_photo_gallery.dart';
import 'package:project_estimator/screens/splash.dart';
import 'package:project_estimator/screens/user_setting.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Construction Estimator',
      routes: {
        '/': (context) => SplashScreen(),
        UserSetting.routeName: (context) => UserSetting(),
        ProjectDetail.routeName: (context) => ProjectDetail(),
        EditProject.routeName: (context) => EditProject(),
        ProjectNotes.routeName: (context) => ProjectNotes(),
        ProjectEstimate.routeName: (context) => ProjectEstimate(),
        EditRoom.routeName: (context) => EditRoom(),
        RoomPhotoGallery.routeName: (context) => RoomPhotoGallery(),
        RoomDetail.routeName: (context) => RoomDetail(),
      },
    );
  }
}