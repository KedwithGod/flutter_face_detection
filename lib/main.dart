import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testing_camera/forFaceRecognition/call.dart';
import 'package:testing_camera/forFaceRecognition/picture_face_recognition.dart';

import 'forFaceRecognition/remotePage.dart';
import 'forFaceRecognition/signalling.dart';



void main() {
  // start videoCall app
  runApp(VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  VideoCallApp({super.key});

   // Check the platform
    bool isAndroid = Platform.isAndroid;
    bool isIOS = Platform.isIOS;

  // signalling server url
  final String websocketUrl = "";

  // generate callerID of local user
  final String selfCallerID =
      Random().nextInt(999999).toString().padLeft(6, '0');



  @override
  Widget build(BuildContext context) {
       String callerId=selfCallerID;   
    // init signalling service
    SignallingService.instance.init(
      websocketUrl: websocketUrl,
      selfCallerID: selfCallerID,
    );

    // return material app
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(),
      ),
      themeMode: ThemeMode.dark,
      home: ImageAnalyzerPage()
    );
  }
}
