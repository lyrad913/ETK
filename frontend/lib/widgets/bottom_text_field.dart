import 'package:flutter/material.dart';

import '../utils/hangul/hangul.dart';
import '../keyboard_states.dart';

class BottomTextField extends StatelessWidget {
  final TextEditingController textController;
  final HangulInput hangulInput;
  final String displayText;
  final VoidCallback onSubmit;
  final void Function() undo;
  final logger;

  const BottomTextField({
    super.key,
    required this.textController,
    required this.hangulInput,
    required this.displayText,
    required this.onSubmit,
    required this.undo,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    String textToDisplay = displayText.isNotEmpty ? displayText : '글자가 출력됩니다.';

    String displayedText = textToDisplay.length >= 15
        ? '...${textToDisplay.substring(textToDisplay.length - 12)}'
        : textToDisplay;

    print(displayedText);
    print(textToDisplay.length);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.group),
              onPressed: () {
                logger.i("커뮤니티 사용");
              },
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  displayedText,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Colors.deepPurpleAccent,
                  onPressed: () {
                    if (hangulInput.text.isNotEmpty) {
                      undo();
                      hangulInput.backspace();
                      logger.i(
                        "'${textController.text.substring(textController.text.length - 1)}' 제거",
                      );
                      textController.text = hangulInput.text;
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: onSubmit,
                  color: Colors.deepPurpleAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
