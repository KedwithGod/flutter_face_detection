class FaceCoordinates {
  final int height;
  final int width;
  final int x;
  final int y;

  FaceCoordinates({required this.height, required this.width, required this.x, required this.y});

  factory FaceCoordinates.fromJson(Map<String, dynamic> json) {
    return FaceCoordinates(
      height: json['height'],
      width: json['width'],
      x: json['x'],
      y: json['y'],
    );
  }
}
