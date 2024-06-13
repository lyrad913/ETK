import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'widgets/background_lines.dart';
import 'widgets/bottom_text_field.dart';
import 'widgets/camera_preview_widget.dart';
import 'widgets/center_button.dart';
import 'widgets/center_content.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  const MyApp({super.key, required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            '시선 추적 키보드',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: CustomUI(
          camera: camera,
        ),
      ),
    );
  }
}

class CustomUI extends StatefulWidget {
  final CameraDescription camera;

  const CustomUI({super.key, required this.camera});

  @override
  _CustomUIState createState() => _CustomUIState();
}

class _CustomUIState extends State<CustomUI> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                const Center(child: BackgroundLines()),
                const CenterContent(),
                Align(
                  alignment: Alignment.topRight,
                  child: CameraPreviewWidget(
                      controller: _controller,
                      future: _initializeControllerFuture),
                ),
                CenterButton(
                  onPressed: () => print('다음 버튼 클릭됨'),
                ),
              ],
            ),
          ),
          BottomTextField(
            textController: _textController,
            onClear: () => _textController.clear(),
            onSubmit: () => print(_textController.text),
          ),
        ],
      ),
    );
  }
}
