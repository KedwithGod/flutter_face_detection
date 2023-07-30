import 'dart:io';
import 'dart:convert'; // Import this library for JSON parsing
import 'package:http/http.dart' as http;

Future<void> detectFace(File imageFile) async {
  var uri = Uri.parse('http://127.0.0.1:5001');
  var request = http.MultipartRequest('POST', uri)
    ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

  var response = await request.send();

  if (response.statusCode == 200) {
    // Parse the JSON response
    String jsonResponse = await response.stream.bytesToString();
    Map<String, dynamic> decodedResponse = jsonDecode(jsonResponse);

    bool faceDetected = decodedResponse['face_detected'];
    if (faceDetected) {
      // Get the face coordinates
      Map<String, dynamic> faceCoordinates = decodedResponse['face_coordinates'];
      int x = faceCoordinates['x'];
      int y = faceCoordinates['y'];
      int width = faceCoordinates['width'];
      int height = faceCoordinates['height'];

      // Do something with the face coordinates
      print('Face detected at x: $x, y: $y, width: $width, height: $height');
    } else {
      print('No face detected.');
    }
  } else {
    print('Error: ${response.reasonPhrase}');
  }
}
