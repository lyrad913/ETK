import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'pages/new_page.dart';
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
      home: CustomUI(camera: camera),
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

  // 문자 세트 정의
  final List<List<String>> consonantPages = [
    ['ㅇ', 'ㄴ', 'ㄱ', 'ㄹ'],
    ['ㅅ', 'ㄷ', 'ㅈ', 'ㅁ'],
    ['ㅎ', 'ㅂ', 'ㅊ', 'ㅌ'],
    ['ㅍ', 'ㅋ']
  ];

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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '시선 추적 키보드',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Center(child: BackgroundLines()),
                  CenterContent(
                    labels: consonantPages[0],
                    onLabelPressed: (label) {
                      setState(() {
                        _textController.text += label;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewPage(
                            camera: widget.camera,
                            labels: const ['ㅏ', 'ㅣ', 'ㅡ', 'ㅓ'],
                            isConsonantPage: false,
                            pageIndex: 0,
                            pages: const [
                              ['ㅏ', 'ㅣ', 'ㅡ', 'ㅓ'],
                              ['ㅗ', 'ㅜ', 'ㅕ', 'ㅐ'],
                              ['ㅔ', 'ㅢ', 'ㅘ', 'ㅙ'],
                              ['ㅛ', 'ㅑ', 'ㅠ']
                            ],
                            textController: _textController,
                          ),
                        ),
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: CameraPreviewWidget(
                      controller: _controller,
                      future: _initializeControllerFuture,
                    ),
                  ),
                  CenterButton(
                    onPressed: () {
                      int nextPageIndex = 1 % consonantPages.length;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewPage(
                            camera: widget.camera,
                            labels: consonantPages[nextPageIndex],
                            isConsonantPage: true,
                            pageIndex: nextPageIndex,
                            pages: consonantPages,
                            textController: _textController,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            BottomTextField(
              textController: _textController,
              onSubmit: () => print(_textController.text),
            ),
          ],
        ),
      ),
    );
  }
}
