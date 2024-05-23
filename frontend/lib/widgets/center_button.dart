import 'package:flutter/material.dart';

class CenterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CenterButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: const Text('다음',
              style: TextStyle(fontSize: 40, color: Colors.grey)),
        ),
      ),
    );
  }
}
