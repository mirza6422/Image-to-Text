import 'dart:io';

import 'package:flutter/foundation.dart';

class ImageState extends ChangeNotifier {
  File? _image;

  File? get image => _image;

  set image(File? value) {
    _image = value;
    notifyListeners();
  }

  File? _editedImage;

  File? get editedImage => _editedImage;

  void setEditedImage(File? value) {
    _editedImage = value;
    notifyListeners();
  }

  String _recognizedText = '';

  String get recognizedText => _recognizedText;

  set recognizedText(String value) {
    _recognizedText = value;
    notifyListeners();
  }

  String _textController = '';

  String get textController => _textController;

  set textController(String value) {
    _textController = value;
    notifyListeners();
  }

  bool _isProcessing = false;

  bool get isProcessing => _isProcessing;

  set isProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }
}
