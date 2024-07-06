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
import 'keyboard_states.dart';

class CustomUI extends StatefulWidget {
  final CameraDescription camera;

  const CustomUI({super.key, required this.camera});

  @override
  CustomUIState createState() => CustomUIState();
}

class CustomUIState extends State<CustomUI> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  final TextEditingController _textController = TextEditingController();
  final logger = Logger();
  List<String> _currentLabels = ['띄어\n쓰기', '입력\n완료', '자음', '모음'];
  bool _isConsonantPage = false;
  bool _isVowelPage = false;
  int _currentPageIndex = 0;
  var korean = Korean();
  String _displayText = '';

  final List<String> stateLabel = ['띄어\n쓰기', '입력\n완료', '자음', '모음'];

  // 문자 세트 정의
  final List<List<String>> consonantPages = [
    ['ㅇ', 'ㄴ', 'ㄱ', 'ㄹ'],
    ['ㅅ', 'ㄷ', 'ㅈ', 'ㅁ'],
    ['ㅎ', 'ㅂ', 'ㅊ', 'ㅌ'],
    ['ㅍ', 'ㅋ']
  ];

  final List<List<String>> vowelPages = [
    ['ㅏ', 'ㅣ', 'ㅡ', 'ㅓ'],
    ['ㅗ', 'ㅜ', 'ㅕ', 'ㅐ'],
    ['ㅔ', 'ㅢ', 'ㅘ', 'ㅙ'],
    ['ㅛ', 'ㅑ', 'ㅠ']
  ];

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
    _textController.addListener(_updateDisplayText);
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.removeListener(_updateDisplayText);
    _textController.dispose();
    super.dispose();
  }

  void _updateDisplayText() {
    setState(() {
      _displayText = korean.moasseugi(_textController.text);
    });
  }

  void _updateLabels(int index) {
    setState(() {
      if (_isConsonantPage) {
        _currentLabels = consonantPages[index];
      } else if (_isVowelPage) {
        _currentLabels = vowelPages[index];
      }
      _currentPageIndex = index;
    });
  }

  void _goToMainPage() {
    setState(() {
      _isConsonantPage = false;
      _isVowelPage = false;
      _currentLabels = stateLabel;
    });
  }

  void _togglePage(String label) {
    if (label == '자음') {
      setState(() {
        _isConsonantPage = true;
        _isVowelPage = false;
        _currentLabels = consonantPages[0];
        _currentPageIndex = 0;
      });
    } else if (label == '모음') {
      setState(() {
        _isConsonantPage = false;
        _isVowelPage = true;
        _currentLabels = vowelPages[0];
        _currentPageIndex = 0;
      });
    } else if (label == '띄어\n쓰기') {
      setState(() {
        _textController.text += ' ';
      });
    } else if (label == '입력\n완료') {
      _saveToFile(_textController.text);
      setState(() {
        _textController.clear();
      });
    }
  }

  void _saveToFile(String text) async {
    text = korean.moasseugi(text);

    var now = DateTime.now();
    var year = now.year;
    var month = now.month;
    var day = now.day;
    var hour = now.hour;
    var minute = now.minute;
    var millisecond = now.millisecond;
    var time = "$year-$month-$day-$hour-$minute-$millisecond";

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/text_input_$time.txt');
    await file.writeAsString(text);
    logger.i('Content: $text File saved at ${file.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '시선 추적 키보드',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  CenterContent(
                    labels: _currentLabels,
                    onLabelPressed: (label) {
                      if (_isConsonantPage || _isVowelPage) {
                        setState(() {
                          _textController.text = _textController.text + label;
                        });
                        _goToMainPage();
                      } else {
                        _togglePage(label);
                      }
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: CameraPreviewWidget(
                      controller: _controller,
                      future: _initializeControllerFuture,
                    ),
                  ),
                  if (_isConsonantPage || _isVowelPage)
                    CenterButton(
                      onPressed: () {
                        int nextPageIndex = (_currentPageIndex + 1) %
                            (_isConsonantPage
                                ? consonantPages.length
                                : vowelPages.length);
                        _updateLabels(nextPageIndex);
                      },
                    ),
                ],
              ),
            ),
            BottomTextField(
              textController: _textController,
              displayText: _displayText,
              korean: korean,
              onSubmit: () => logger.i(korean.moasseugi(_textController.text)),
              logger: logger,
            ),
          ],
        ),
      ),
    );
  }
}