import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:testing_camera/model/face_result.dart';
import 'dart:ui' as ui;

class ImageAnalyzerPage extends StatefulWidget {
  const ImageAnalyzerPage({super.key});

  @override
  _ImageAnalyzerPageState createState() => _ImageAnalyzerPageState();
}

class _ImageAnalyzerPageState extends State<ImageAnalyzerPage> {
  final File _image=File('/Users/user/Development/mobile_apps/testing_camera/lib/forFaceRecognition/hansome.jpeg');
  bool _faceDetected = false;
  FaceCoordinates? _faceCoordinates;
  int imageWidth = 0;
  int imageHeight = 0;



  Future<void> _analyzeImage() async {
    if (_image == null) {
      return;
    }

    final url = Uri.parse('http://127.0.0.1:5001/detect_face');

    // Create a multipart request with the image file
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('image', _image.path));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(await response.stream.bytesToString());
      
        final faceDetected = jsonResponse['face_detected'] ?? false;
        

        if (faceDetected) {
          setState(() {
            _faceDetected = true;
            _faceCoordinates = FaceCoordinates.fromJson(jsonResponse['face_coordinates']);
              print(_faceCoordinates!.y);
          });
        } else {
          setState(() {
            _faceDetected = false;
            _faceCoordinates = null;
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  void evalutateImageSize()async{
    // Read the image file as bytes
List<int> imageBytes = await _image.readAsBytes();

// Decode the image bytes to get its size
ui.Codec codec = await ui.instantiateImageCodec(Uint8List.fromList(imageBytes));
ui.FrameInfo frameInfo = await codec.getNextFrame();
imageWidth = frameInfo.image.width;
imageHeight = frameInfo.image.height;

print('Image Width: $imageWidth');
print('Image Height: $imageHeight');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  evalutateImageSize();

  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth=MediaQuery.of(context).size.width;
    print(phoneWidth);
    double phoneHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Analyzer'),
        actions: [ ElevatedButton(
              onPressed: () async {
                await _analyzeImage();
              },
              child: const Text('Analyze'),
            )],
      ),
      body: Stack(
        children: [
          _image != null
              ? Container(
                width: phoneWidth,
                height: 300,
                color: Colors.blue,
                child: Image.file(_image,fit: BoxFit.cover,
                 
                ),
              )
              : Container(),
         
         
          if (_faceDetected && _faceCoordinates != null)
            Positioned(
              top:_faceCoordinates!.y.toDouble()*phoneWidth/imageWidth,
              left: _faceCoordinates!.x.toDouble()*phoneWidth/imageWidth,
              child: Container(
                height: _faceCoordinates!.height.toDouble()*phoneWidth/imageWidth,
                width: _faceCoordinates!.width.toDouble()*phoneWidth/imageWidth,
              
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
