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
import 'custom_ui.dart';

// TODO: 
// 1. Handling Undo
// 2. Enum gaze
// 3. 이중 모음 입력 시 예외 발생
//    3.1. 'ㅢ'로 입력하면 문제 없으나, 'ㅡ', 'ㅣ' 와 
//          같이 입력하면 예외가 발생함. korean 자체의 문제로 보임
//          제일 까다로운 문제일지도..

abstract class KeyboardState{
  String board = "";
  // TODO: 나중에는 int gaze가 아니라, [type] input 으로 변경하는 것이 좋아보임.
  void handleInput(CustomUIState context, int gaze);
}

// 0 : top, 1 : bottom, 2 : left, 3: right, 4: center
// TODO: Enum타입으로 정의해서, 명확하게 의미 전달할것.
// ex) enum input(top, bottom, left, right, center, undo, enter.....)
// 우선 undo나 기타는 고려하지 않고 구현함. 수정해서 사용.
class S0State implements KeyboardState{ // NULL
  @override
  String board = "consonant";
  @override
  void handleInput(CustomUIState context, int gaze) {
    if(gaze == 4){
      context.incrementIdx();
      context.updateLabels(context.getIdx(), board);
    } else {
      String text = 
        context.consonantPages[context.getIdx()][gaze];
      context.inputText(text);
      context.changeState(S1State());
    }
  }
}

class S1State implements KeyboardState{ // O
  @override
  String board = "vowel";
  @override
  void handleInput(CustomUIState context, int gaze) {
    if(gaze == 4){
      context.incrementIdx();
      context.updateLabels(context.getIdx(), board);
    } else {
      String text = 
        context.vowelPages[context.getIdx()][gaze];
      context.inputText(text);
      context.changeState(S2State());
    }
  }
}

class S2State implements KeyboardState{ // ON
  bool firstSelect = true;

  @override
  String board = 'select';

  @override
  void handleInput(CustomUIState context, int gaze){
    if(firstSelect){
      if(gaze == 0) { // top(consonant)
        board = 'consonant';
        context.updateLabels(0, board);
        firstSelect = !firstSelect;
      } else if(gaze == 1){ // bottom(vowel)
        board = 'vowel';
        context.updateLabels(0, 'vowel');
        firstSelect = !firstSelect;
      } // do nothing in center
    } else {
      if(gaze == 4){
        context.incrementIdx();
        context.updateLabels(context.getIdx(), board);
      }else{
        String text = (board == 'consonant') ?
          context.consonantPages[context.getIdx()][gaze]:
          context.vowelPages[context.getIdx()][gaze];
        context.inputText(text);
        (board == 'consonant') ? context.changeState(S4State()) 
                               : context.changeState(S3State());
      }
    }
  }
}

class S3State implements KeyboardState{ // ONN
  @override
  String board = 'consonant';

  @override
  void handleInput(CustomUIState context, int gaze) {
    if(gaze == 4){
      context.incrementIdx();
      context.updateLabels(context.getIdx(), board);
    } else {
      String text = 
        context.consonantPages[context.getIdx()][gaze];
      context.inputText(text);
      context.changeState(S5State());
    }
  }
}

class S4State implements KeyboardState{ // ONC
  @override
  String board = 'select';

  @override
  void handleInput(CustomUIState context, int gaze) {
    if(gaze == 0) { // top(consonant)
        context.changeState(S0State());
      } else if(gaze == 1){ // bottom(vowel)
        context.changeState(S1State());
      } // do nothing in center
  }
}

class S5State implements KeyboardState{ // ONNC
  @override
  String board = 'select';

  @override
  void handleInput(CustomUIState context, int gaze) {
    if(gaze == 0) { // top(consonant)
        context.changeState(S0State());
      } else if(gaze == 1){ // bottom(vowel)
        context.changeState(S1State());
      } // do nothing in center
  }
}