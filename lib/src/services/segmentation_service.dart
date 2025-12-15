import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart';

/// Demo SegmentationService
///
/// Produces a simple hair mask image using face bounding boxes when a real
/// segmentation model isn't available. The mask is an RGBA PNG with green
/// region where "hair" is estimated (ellipse above the face rect).
class SegmentationService {
  Future<File> generateMask(File image, List<Face> faces) async {
    final imageBytes = await image.readAsBytes();
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final img = frame.image;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()));

    // Clear transparent
    final paintClear = Paint()..blendMode = BlendMode.clear;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        paintClear);

    // Draw mask based on faces
    final maskPaint = Paint()
      ..color = const Color.fromARGB(160, 0, 180, 80); // semi-transparent green

    if (faces.isNotEmpty) {
      for (final f in faces) {
        final rect = f.boundingBox;
        // estimate hair region as an ellipse above the face bounding box
        final cx = rect.center.dx;
        final cy = rect.top - rect.height * 0.25;
        final rx = rect.width * 0.9;
        final ry = rect.height * 0.9;
        final hairRect =
            Rect.fromCenter(center: Offset(cx, cy), width: rx, height: ry);
        canvas.drawOval(hairRect, maskPaint);
      }
    } else {
      // fallback: center oval
      final hairRect = Rect.fromCenter(
          center: Offset(img.width / 2, img.height / 3),
          width: img.width * 0.8,
          height: img.height * 0.3);
      canvas.drawOval(hairRect, maskPaint);
    }

    final picture = recorder.endRecording();
    final pngBytes = await picture
        .toImage(img.width, img.height)
        .then((i) => i.toByteData(format: ui.ImageByteFormat.png))
        .then((b) => b!.buffer.asUint8List());

    Directory tmpDir;
    try {
      final tmp = await getTemporaryDirectory();
      tmpDir = Directory(tmp.path);
    } catch (e) {
      // In test environments path_provider may not be available; fallback to system temp
      tmpDir = Directory.systemTemp;
    }
    final outFile = File(
        '${tmpDir.path}/mask_${DateTime.now().millisecondsSinceEpoch}.png');
    await outFile.writeAsBytes(pngBytes);
    return outFile;
  }
}
