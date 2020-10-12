import 'dart:async';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StoryBloc extends ChangeNotifier {
  bool _isImagePositionSaved = false;
  bool get getImagePositionState => _isImagePositionSaved;
  bool _isTextEnabled = false;
  bool get getTextEnabled => _isTextEnabled;

  Matrix4 _currentImagePosition = Matrix4.identity();
  Matrix4 get getCurrenImagePosition => _currentImagePosition;

  ValueNotifier<Matrix4> notifierPicture = ValueNotifier(Matrix4.identity());
  ValueNotifier<Matrix4> notifierText = ValueNotifier(Matrix4.identity());

  ValueNotifier get getNotifierPicture => notifierPicture;
  ValueNotifier get getNotifierText => notifierText;

  StreamController<Matrix4> _stream = StreamController.broadcast();
  Stream<Matrix4> get getPosition => _stream.stream;

  CrossAxisAlignment _textAlign = CrossAxisAlignment.center;
  CrossAxisAlignment get getTextAlignment => _textAlign;

  TextAlign _align = TextAlign.center;
  TextAlign get getAlign => _align;

  Color _color = AppStyle.colorRed;
  Color get getTextColor => _color;

  bool _isBorderEnabled = false;
  bool get getBorderEnabled => _isBorderEnabled;

  StoryBloc() {
    notifierPicture.addListener(() {
      this._currentImagePosition = notifierPicture.value;
    });
  }

  setImagePositionState(bool val) {
    this._isImagePositionSaved = val;
    notifyListeners();
  }

  setUndoState(bool val) {
    this._isImagePositionSaved = val;
    this._currentImagePosition = Matrix4.identity();
    notifyListeners();
  }

  setClearStoryData() {
    this._currentImagePosition = Matrix4.identity();
    this._align = TextAlign.center;
    this._color = AppStyle.colorRed;
    this._isTextEnabled = false;
    this._textAlign = CrossAxisAlignment.center;
    // notifier = ValueNotifier(Matrix4.identity());
    this._isImagePositionSaved = false;
    notifyListeners();
  }

  setTextEnabled(bool val) {
    this._isTextEnabled = val;
    notifyListeners();
  }

  setTextAlign() {
    switch (_textAlign) {
      case CrossAxisAlignment.center:
        _textAlign = CrossAxisAlignment.start;
        _align = TextAlign.start;
        notifyListeners();
        break;
      case CrossAxisAlignment.start:
        _textAlign = CrossAxisAlignment.end;
        _align = TextAlign.end;
        notifyListeners();

        break;
      case CrossAxisAlignment.end:
        _textAlign = CrossAxisAlignment.center;
        _align = TextAlign.center;
        notifyListeners();

        break;
      default:
    }
  }

  setTextColor() {
    if (_color == AppStyle.colorRed) {
      _color = AppStyle.colorDark;
      notifyListeners();
    } else if (_color == AppStyle.colorDark) {
      _color = AppStyle.colorRed;
      notifyListeners();
    }
  }

  setBorderEnabled() {
    this._isBorderEnabled = true;
    notifyListeners();
  }

  setBorderDisabled() {
    this._isBorderEnabled = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _stream?.close();
    super.dispose();
  }
}
