import 'package:flutter/material.dart';

class BottomTextField extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onClear;
  final VoidCallback onSubmit;

  const BottomTextField({
    super.key,
    required this.textController,
    required this.onClear,
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
            hintText: '시선 추적',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.undo),
                  onPressed: onClear,
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: onSubmit,
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
