import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceResultScreen extends StatelessWidget {
  final File image;
  final List<Face> faces;

  const FaceResultScreen({super.key, required this.image, required this.faces});

  @override
  Widget build(BuildContext context) {
    final hasFace = faces.isNotEmpty;
    // Show first detected face details if available
    // Use the first detected face if needed in future

    return Scaffold(
      appBar: AppBar(title: const Text('Detection Result')),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: Image.file(image, fit: BoxFit.cover)),
                if (hasFace)
                  Positioned.fill(
                    child: CustomPaint(painter: FacePainter(faces)),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  hasFace
                      ? 'Detected ${faces.length} face(s)'
                      : 'No face detected',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Retake'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(hasFace),
                        child: const Text('Use Photo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  final List<Face> faces;
  FacePainter(this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.greenAccent;
    final pointPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.redAccent;
    for (final f in faces) {
      final rect = f.boundingBox;
      // draw rect (assume image fits the box)
      canvas.drawRect(rect, paint);
      // draw any available landmarks from the face
      final lmMap = f.landmarks;
      for (final lm in lmMap.values) {
        if (lm != null) {
          final pos = lm.position;
          canvas.drawCircle(
              Offset(pos.x.toDouble(), pos.y.toDouble()), 4.0, pointPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
