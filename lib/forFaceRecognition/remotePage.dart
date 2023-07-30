import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  WebSocketChannel? _channel;
  bool runOnce=true;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeWebSocket();

  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    await _controller!.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _initializeWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse("ws://127.0.0.1:5051"));
     _channel!.sink.add('recording');
  }

  void _sendFrame(Uint8List frameData) async{
    if (_channel != null && _channel!.sink != null) {
       // Compress the image using flutter_image_compress
  // List<int> compressedImageData = await FlutterImageCompress.compressWithList(
  //   frameData,
  //   quality: 85, // Adjust the quality level as needed (0-100)
  //   format: CompressFormat.jpeg, // Use CompressFormat.png for PNG images
  // );

   
        _channel!.sink.add(jsonEncode(frameData));
     
    }
  }

  void _startRecording() {
     _channel!.sink.add('recording');
    // if (_controller != null && _controller!.value.isInitialized) {
      _controller!.startImageStream((CameraImage image) {
        final frameData = image.planes[0].bytes;
        // print(frameData);
     // Send the frame data in chunks of 2048 bytes each
        int offset = 0;
        while (offset < frameData.length) {
          int length = 2048;
          if (offset + length > frameData.length) {
            length = frameData.length - offset;
          }

          // Get the chunk of frame data
          Uint8List chunk = frameData.sublist(offset, offset + length);

          // Send the chunk over the WebSocket
           _channel!.sink.add(jsonEncode(chunk));

          // Move the offset to the next chunk
          offset += length;
        }
      });
   
    // }
  }

  void _stopRecording() {
    if (_controller != null && _controller!.value.isInitialized) {
      _controller!.stopImageStream();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _channel?.sink?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Camera Stream')),
      body: Center(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: CameraPreview(_controller!),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startRecording,
        child: Text('start record')
      ),
    );
  }
}
