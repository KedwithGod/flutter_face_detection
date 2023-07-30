import 'dart:developer';

import 'package:web_socket_channel/web_socket_channel.dart';

class SignallingService {
  // instance of Socket
  WebSocketChannel? channel;
  Stream? socketListen;

  SignallingService._();
  static final instance = SignallingService._();

  init({required String websocketUrl, required String selfCallerID}) {
   try {
      final wsUrl = Uri.parse(websocketUrl);
   channel = WebSocketChannel.connect(wsUrl);
      socketListen=channel!.stream.asBroadcastStream();

  // channel.stream.listen((message) {
  //   channel.sink.add('received!');
  //   channel.sink.close(status.goingAway);
  // });
   } catch (error,stacktrace) {
    print(error.toString());
     
   }
   }
}