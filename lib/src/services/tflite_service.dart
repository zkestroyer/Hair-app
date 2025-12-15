import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';

class TFLiteService {
  Interpreter? _interpreter;

  Future<void> loadModel(String assetName) async {
    _interpreter = await Interpreter.fromAsset(assetName);
  }

  // Placeholder run method - implementation depends on model
  List<double> run(Uint8List input) {
    // Simple stub that references the interpreter so the field is considered used
    if (_interpreter == null) return [];
    // TODO: preprocess input and run model with `_interpreter`
    return [];
  }
}
