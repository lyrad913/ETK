import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import 'utils/hangul/hangul.dart';
import 'widgets/bottom_text_field.dart';
import 'widgets/camera_preview_widget.dart';
import 'widgets/center_button.dart';
import 'widgets/center_content.dart';
import 'custom_ui.dart';

// TODO: 
// 1. Handling Undo
// 2. Enum gaze

abstract class KeyboardState{
  String board = "";
  // TODO: 나중에는 int gaze가 아니라, [type] input 으로 변경하는 것이 좋아보임.
  void handleInput(CustomUIState context, int gaze);
  void undo(CustomUIState context);
}

// 0 : top, 1 : bottom, 2 : left, 3: right, 4: center
// TODO: Enum타입으로 정의해서, 명확하게 의미 전달할것.
// ex) enum input(top, bottom, left, right, center, undo, enter.....)
// 우선 undo나 기타는 고려하지 않고 구현함. 수정해서 사용.
class S0State implements KeyboardState{ // NULL
  String prevState = '';

  S0State(this.prevState){
    print('State: S0(NULL)');
  }

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

  @override
  void undo(CustomUIState context){
    switch (prevState){
      case 's4':
        context.changeState(S4State());
        break;
      case 's5':
        context.changeState(S5State());
        break;
      default:
        break;
    }
  }
}

class S1State implements KeyboardState{ // O
  S1State(){
      print('State: S1(초성)');
  }

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
  @override
  void undo(CustomUIState context) {
    context.changeState(S0State(''));
  }
}

class S2State implements KeyboardState{ // ON
  bool firstSelect = true;

  S2State(){
      print('State: S2(초성 + 중성)');
  }

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
  @override
  void undo(CustomUIState context) {
    context.changeState(S1State());
  }
}

class S3State implements KeyboardState{ // ONN
  S3State(){
      print('State: S3(초성 + 중성 + 중성)');
  }

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
  @override
  void undo(CustomUIState context) {
    context.changeState(S2State());
  }
}

class S4State implements KeyboardState{ // ONC
  S4State(){
      print('State: S4(초성 + 중성 + 종성)');
  }

  @override
  String board = 'select';

  @override
  void handleInput(CustomUIState context, int gaze) {
    if(gaze == 0) { // top(consonant)
        context.changeState(S0State('s4'));
      } else if(gaze == 1){ // bottom(vowel)
        context.changeState(S1State());
      } // do nothing in center
  }
  @override
  void undo(CustomUIState context) {
    context.changeState(S2State());
  }
}

class S5State implements KeyboardState{ // ONNC
  S5State(){
      print('State: S5(초성 + 중성 + 중성 + 종성)');
  }


  @override
  String board = 'select';

  @override
  void handleInput(CustomUIState context, int gaze) {
    if(gaze == 0) { // top(consonant)
        context.changeState(S0State('s5'));
      } else if(gaze == 1){ // bottom(vowel)
        context.changeState(S1State());
      } // do nothing in center
  }
  @override
  void undo(CustomUIState context) {
    context.changeState(S3State());
  }
}