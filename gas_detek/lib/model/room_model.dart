import 'dart:ui';

class Room {
  final String text;
  final String lessons;
  final String imageUrl;
  final double percent;
  final String backImage;
  final Color color;

  Room({
    required this.text,
    required this.lessons,
    required this.imageUrl,
    required this.percent,
    required this.backImage,
    required this.color,
  });
}
