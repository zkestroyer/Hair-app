import 'dart:io';
import 'package:image/image.dart' as img;

import 'package:flutter_test/flutter_test.dart';
import 'package:hair_guidance_app/src/services/segmentation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generate mask produces a file', () async {
    final service = SegmentationService();
    // Create a 100x100 blank PNG to use as input
    final tmp = Directory.systemTemp.createTempSync();
    final file = File('${tmp.path}/test.png');

    final img.Image image = img.Image(100, 100);
    img.fill(image, img.getColor(255, 255, 255));
    final pngBytes = img.encodePng(image);
    await file.writeAsBytes(pngBytes);

    final mask = await service.generateMask(file, []);
    expect(await mask.exists(), isTrue);
    // cleanup
    tmp.deleteSync(recursive: true);
  });
}
