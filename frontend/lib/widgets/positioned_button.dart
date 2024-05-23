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
          child: Text(label, style: const TextStyle(fontSize: 50)),
        ),
      ),
    );
  }
}
