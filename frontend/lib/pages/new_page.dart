import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../widgets/background_lines.dart';
import '../widgets/bottom_text_field.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/center_button.dart';
import '../widgets/center_content.dart';

class NewPage extends StatefulWidget {
  final CameraDescription camera;
  final List<String> labels;
  final bool isConsonantPage;
  final int pageIndex;
  final List<List<String>> pages;
  final TextEditingController textController;

  const NewPage({
    super.key,
    required this.camera,
    required this.labels,
    required this.isConsonantPage,
    required this.pageIndex,
    required this.pages,
    required this.textController,
  });

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

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

  void _onLabelPressed(String label) {
    setState(() {
      widget.textController.text += label;
    });

    if (widget.isConsonantPage) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPage(
            camera: widget.camera,
            labels: _vowelPages[0],
            isConsonantPage: false,
            pageIndex: 0,
            pages: _vowelPages,
            textController: widget.textController,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPage(
            camera: widget.camera,
            labels: _consonantPages[0],
            isConsonantPage: true,
            pageIndex: 0,
            pages: _consonantPages,
            textController: widget.textController,
          ),
        ),
      );
    }
  }

  List<List<String>> get _consonantPages => [
        ['ㅇ', 'ㄴ', 'ㄱ', 'ㄹ'],
        ['ㅅ', 'ㄷ', 'ㅈ', 'ㅁ'],
        ['ㅎ', 'ㅂ', 'ㅊ', 'ㅌ'],
        ['ㅍ', 'ㅋ']
      ];

  List<List<String>> get _vowelPages => [
        ['ㅏ', 'ㅣ', 'ㅡ', 'ㅓ'],
        ['ㅗ', 'ㅜ', 'ㅕ', 'ㅐ'],
        ['ㅔ', 'ㅢ', 'ㅘ', 'ㅙ'],
        ['ㅛ', 'ㅑ', 'ㅠ']
      ];

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
                    labels: widget.labels,
                    onLabelPressed: _onLabelPressed,
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
                      int nextPageIndex =
                          (widget.pageIndex + 1) % widget.pages.length;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewPage(
                            camera: widget.camera,
                            labels: widget.pages[nextPageIndex],
                            isConsonantPage: widget.isConsonantPage,
                            pageIndex: nextPageIndex,
                            pages: widget.pages,
                            textController: widget.textController,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            BottomTextField(
              textController: widget.textController,
              onSubmit: () => print(widget.textController.text),
            ),
          ],
        ),
      ),
    );
  }
}
