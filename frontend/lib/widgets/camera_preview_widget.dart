import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPreviewWidget extends StatelessWidget {
  final CameraController controller;
  final Future<void> future;

  const CameraPreviewWidget(
      {super.key, required this.controller, required this.future});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<void>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SizedBox(
                width: 100,
                height: 100,
                child: ClipOval(
                  child: CameraPreview(controller),
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
