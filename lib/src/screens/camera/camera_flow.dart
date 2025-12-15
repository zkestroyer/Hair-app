import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hair_guidance_app/src/screens/camera/face_result.dart';
import 'package:hair_guidance_app/src/screens/consent_screen.dart';
import 'package:hair_guidance_app/src/services/face_service.dart';
import 'package:path_provider/path_provider.dart';

class CameraFlow extends StatefulWidget {
  const CameraFlow({super.key});

  @override
  State<CameraFlow> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {
  CameraController? _controller;
  bool _initialized = false;
  bool _taking = false;
  late FaceService _faceService;

  @override
  void initState() {
    super.initState();
    _faceService = FaceService();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    // choose front camera if available
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _controller = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _controller!.initialize();
    if (!mounted) return;
    setState(() => _initialized = true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guided Selfie')),
      body: _initialized && _controller != null
          ? Stack(
              children: [
                CameraPreview(_controller!),
                // circular overlay guide
                Center(
                  child: IgnorePointer(
                    child: Container(
                      width: 260,
                      height: 340,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FloatingActionButton(
                        onPressed: _taking ? null : _capture,
                        child: _taking
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Icon(Icons.camera),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _capture() async {
    if (_controller == null) return;
    setState(() => _taking = true);
    try {
      final xfile = await _controller!.takePicture();
      final tmpDir = await getTemporaryDirectory();
      final saved = await _saveToTemp(xfile, tmpDir.path);
      // run face detection
      final input = InputImage.fromFilePath(saved.path);
      final faces = await _faceService.detectFaces(input);

      // generate mask (demo) using faces
      final maskFile = await SegmentationService().generateMask(saved, faces);

      // Show result screen with mask overlay
      final consent = await Navigator.of(context).push<bool?>(
        MaterialPageRoute(
          builder: (_) =>
              FaceResultScreen(image: saved, faces: faces, mask: maskFile),
        ),
      );
      // consent handling (FaceResultScreen may return true to indicate user wants to upload)
      if (consent == true) {
        final uploadConsent = await Navigator.of(
          context,
        ).push<bool>(MaterialPageRoute(builder: (_) => const ConsentScreen()));
        if (uploadConsent == true) {
          // TODO: upload to Firebase Storage (placeholder)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uploading image... (placeholder)')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
    } finally {
      if (mounted) setState(() => _taking = false);
    }
  }

  Future<File> _saveToTemp(XFile file, String dir) async {
    final dest = File('$dir/${DateTime.now().millisecondsSinceEpoch}.jpg');
    return File(file.path).copy(dest.path);
  }
}
