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

abstract class KeyboardState{
  void handleInput(CustomUIState context, String gaze);
  List<String> getLabels(CustomUIState context);
}

class S0State implements KeyboardState{
  @override
  void handleInput(CustomUIState context, String gaze) {
    
  }
}