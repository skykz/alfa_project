import 'dart:async';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/screens/home/create_edit_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class StoryBloc extends ChangeNotifier {
  StoryBloc() {
    notifierPicture.addListener(() {
      this._currentImagePosition = notifierPicture.value;
    });
    notifierText.addListener(() {
      this._currentTextPosition = notifierText.value;
    });
  }

  bool _isImagePositionSaved = false;
  bool _isTextPositionSaved = false;

  Color _backgColor = Colors.white;
  Color get getBackColor => _backgColor;

  bool get getImagePositionState => _isImagePositionSaved;
  bool get getTextPositionSaved => _isTextPositionSaved;

  bool _isTextEnabled = false;
  bool get getTextEnabled => _isTextEnabled;

  Matrix4 _currentImagePosition = Matrix4.identity();
  Matrix4 get getCurrenImagePosition => _currentImagePosition;

  Matrix4 _currentTextPosition = Matrix4.identity();
  Matrix4 get getCurrenTextPosition => _currentTextPosition;

  // Matrix4 _currentDecorationPosition = Matrix4.identity();
  // Matrix4 get getCurrenDecorationPosition => _currentDecorationPosition;

  ValueNotifier<Matrix4> notifierPicture = ValueNotifier(Matrix4.identity());
  ValueNotifier<Matrix4> notifierText = ValueNotifier(Matrix4.identity());
  ValueNotifier<Matrix4> notifierDecoration = ValueNotifier(Matrix4.identity());
  // Matrix4 matrix = Matrix4.identity();
  Boxer boxer;
  Boxer get getBoxer => boxer;

  setBoxer(val) {
    this.boxer = val;
    notifyListeners();
  }

  ValueNotifier get getNotifierPicture => notifierPicture;
  ValueNotifier get getNotifierText => notifierText;
  ValueNotifier get getNotifierDecoration => notifierDecoration;

  StreamController<Matrix4> _stream = StreamController.broadcast();
  Stream<Matrix4> get getPosition => _stream.stream;

  CrossAxisAlignment _textAlign = CrossAxisAlignment.center;
  CrossAxisAlignment get getTextAlignment => _textAlign;

  TextAlign _align = TextAlign.center;
  TextAlign get getAlign => _align;

  Color _color = AppStyle.colorRed;
  Color get getTextColor => _color;

  double _textWidthContainer = 150;
  double get textWidthContainer => _textWidthContainer;

  FontWeight _fontWeightCustom = FontWeight.normal;
  FontWeight get getCustomTextWeight => _fontWeightCustom;

  String _title;
  String _body;

  String get getTitle => _title;
  String get getBody => _body;

  String _decorationImageUrl;
  String get getDecorationImageUrl => _decorationImageUrl;

  bool _isRemoveEnabled = false;
  bool get getRemoveEnabled => _isRemoveEnabled;

  setRemoveButtonStatus(bool val) {
    this._isRemoveEnabled = val;
    notifyListeners();
  }

  setImagePositionState(bool val) {
    this._isImagePositionSaved = val;
    notifyListeners();
  }

  setTextPosition(bool val) {
    this._isTextPositionSaved = val;
    notifyListeners();
  }

  setUndoImageState(bool val) {
    this._isImagePositionSaved = val;
    this._currentImagePosition = Matrix4.identity();
    notifyListeners();
  }

  setUndoTextState(bool val) {
    this._isTextPositionSaved = val;
    this._isTextEnabled = val;
    this._currentTextPosition = Matrix4.identity();
    this._title = null;
    this._body = null;
    this._color = AppStyle.colorRed;
    this._textWidthContainer = 150;
    this._fontWeightCustom = FontWeight.normal;

    notifyListeners();
  }

  setStoryBackgroundColor(Color valueColor) {
    this._backgColor = valueColor;
    notifyListeners();
  }

  setClearStoryData() {
    this._currentImagePosition = Matrix4.identity();
    this._align = TextAlign.center;
    this._color = AppStyle.colorRed;
    this._isTextEnabled = false;
    this._textAlign = CrossAxisAlignment.center;
    this._isTextEnabled = false;
    this._isTextPositionSaved = false;
    this._currentTextPosition = Matrix4.identity();
    this._isImagePositionSaved = false;
    this._title = null;
    this._body = null;
    this._color = AppStyle.colorRed;
    this._textWidthContainer = 150;
    this._fontWeightCustom = FontWeight.normal;
    _isRemoveEnabled = false;
    // notifierPicture = ValueNotifier(Matrix4.identity());
    // notifierText = ValueNotifier(Matrix4.identity());
    notifierDecoration = ValueNotifier(Matrix4.identity());
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

  setTextWidthContainer(double val) {
    this._textWidthContainer = val;
    notifyListeners();
  }

  setFontCustomWeight() {
    this._fontWeightCustom = this._fontWeightCustom == FontWeight.normal
        ? FontWeight.bold
        : FontWeight.normal;
    notifyListeners();
  }

  setTitleBodyString(String title, String body) {
    this._title = title;
    this._body = body;
    notifyListeners();
  }

  setDecorationImage(String url) {
    this._decorationImageUrl = url;
    if (url == null)
      this.notifierDecoration = ValueNotifier(Matrix4.identity());
    notifyListeners();
  }

  @override
  void dispose() {
    _stream?.close();
    super.dispose();
  }
}
