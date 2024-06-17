import 'package:flutter/material.dart';

import 'positioned_button.dart';

class CenterContent extends StatelessWidget {
  final List<String> labels;
  final Function(String) onLabelPressed;

  const CenterContent({
    super.key,
    required this.labels,
    required this.onLabelPressed,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = [];

    if (labels.isNotEmpty) {
      buttons.add(
        PositionedButton(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 20.0),
          label: labels[0],
          onPressed: () => onLabelPressed(labels[0]),
        ),
      );
    }
    if (labels.length > 1) {
      buttons.add(
        PositionedButton(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 20.0),
          label: labels[1],
          onPressed: () => onLabelPressed(labels[1]),
        ),
      );
    }
    if (labels.length > 2) {
      buttons.add(
        PositionedButton(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20.0),
          label: labels[2],
          onPressed: () => onLabelPressed(labels[2]),
        ),
      );
    }
    if (labels.length > 3) {
      buttons.add(
        PositionedButton(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          label: labels[3],
          onPressed: () => onLabelPressed(labels[3]),
        ),
      );
    }

    return Stack(children: buttons);
  }
}
