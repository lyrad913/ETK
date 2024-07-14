import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'utils/korean.dart';
import 'widgets/bottom_text_field.dart';
import 'widgets/camera_preview_widget.dart';
import 'widgets/center_button.dart';
import 'widgets/center_content.dart';
import 'custom_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  CameraDescription? frontCamera;

  // 전면 카메라를 찾기
  for (var camera in cameras) {
    if (camera.lensDirection == CameraLensDirection.front) {
      frontCamera = camera;
      break;
    }
  }

  if (frontCamera == null) {
    throw Exception('전면 카메라를 찾을 수 없습니다.');
  }

  runApp(MyApp(camera: frontCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurpleAccent,
          ),
          bodyLarge: TextStyle(
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
      ),
      home: CustomUI(camera: camera),
    );
  }
}


