import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RemoteStreamHandler {
  final WebSocketChannel channel;
  MediaStream? _remoteStream;

  RemoteStreamHandler(this.channel) {
    _initialize();
  }

  void _initialize() {
    channel.stream.listen((message) {
      final data = jsonDecode(message);
      final type = data['type'];
      final jsonData = data['data'];

      if (type == 'localStream') {
        // _onLocalStreamReceived(jsonData);
      }
    });
  }

  // void _onLocalStreamReceived(Map<dynamic, dynamic> data) async {
  //   if (_remoteStream != null) {
  //     return;
  //   }

  //   final stream = MediaStream.fromMap(data);
  //   _remoteStream = stream;
  // }

  MediaStream? get remoteStream => _remoteStream;
}
