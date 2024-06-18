import 'package:flutter/material.dart';

class BottomTextField extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onSubmit;

  const BottomTextField({
    super.key,
    required this.textController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textController,
          decoration: InputDecoration(
            prefixIcon: IconButton(
              icon: const Icon(Icons.group),
              onPressed: () {
                // 커뮤니티 이동 버튼 클릭 시 수행할 작업
              },
            ),
            hintText: '입력하신 글자가 출력됩니다.',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Colors.deepPurpleAccent,
                  onPressed: () => {
                    print(
                      "'${textController.text.substring(textController.text.length - 1, textController.text.length)}' 제거",
                    ),
                    textController.text = textController.text
                        .substring(0, textController.text.length - 1),
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: onSubmit,
                  color: Colors.deepPurpleAccent,
                ),
              ],
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
