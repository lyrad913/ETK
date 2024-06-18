import 'package:flutter/material.dart';

class PositionedButton extends StatelessWidget {
  final Alignment alignment;
  final EdgeInsets padding;
  final String label;
  final VoidCallback onPressed;

  const PositionedButton({
    super.key,
    required this.alignment,
    required this.padding,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
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
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
