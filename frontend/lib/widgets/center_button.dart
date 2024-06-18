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
          width: 130,
          height: 130,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 4,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text('다음',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }
}
