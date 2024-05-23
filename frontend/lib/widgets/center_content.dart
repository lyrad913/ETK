import 'package:flutter/material.dart';

import 'positioned_button.dart';

class CenterContent extends StatelessWidget {
  const CenterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PositionedButton(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 20.0),
          label: 'ㅇ',
          onPressed: () => print('ㅇ 버튼 클릭됨'),
        ),
        PositionedButton(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 20.0),
          label: 'ㅈ',
          onPressed: () => print('ㅈ 버튼 클릭됨'),
        ),
        PositionedButton(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20.0),
          label: 'ㄱ',
          onPressed: () => print('ㄱ 버튼 클릭됨'),
        ),
        PositionedButton(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          label: 'ㅅ',
          onPressed: () => print('ㅅ 버튼 클릭됨'),
        ),
      ],
    );
  }
}
