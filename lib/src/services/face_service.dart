// ignore_for_file: unused_import
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceService {
  final options = FaceDetectorOptions(
    enableContours: true,
    enableClassification: true,
  );

  Future<List<Face>> detectFaces(InputImage inputImage) async {
    final detector = FaceDetector(options: options);
    final faces = await detector.processImage(inputImage);
    await detector.close();
    return faces;
  }
}
