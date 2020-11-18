import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui' as ui;
import 'package:image/image.dart' as image;

class StoryBloc extends ChangeNotifier {
  StoryBloc() {
    notifierPicture.addListener(() {
      this._currentImagePosition = notifierPicture.value;
    });
  }
  List<Widget> _childrenStickers = List();
  List<Widget> get getChildrenStickers => _childrenStickers;

  bool _isLoading = false;
  bool get getLoading => _isLoading;

  bool _isLoadingDownload = false;
  bool get getLoadingDownload => _isLoadingDownload;

  bool _isStoryTemplate = false;
  bool get getIsStoryTemplate => this._isStoryTemplate;

  StreamController<bool> streamController = StreamController<bool>.broadcast();
  Stream get getLoadingStream => streamController.stream;

  setTypeOfAlfa(bool val) {
    this._isStoryTemplate = val;
    notifyListeners();
  }

  setLoading(bool val) {
    this._isLoading = val;
    notifyListeners();
  }

  setLoadingDownload(bool val) {
    this._isLoading = val;
    notifyListeners();
  }

  String _imageUrl;
  String get getImageUrl => _imageUrl;

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

  Offset offset = Offset(50, 100);
  Offset get getOffset => offset;

  ValueNotifier<Matrix4> notifierPicture = ValueNotifier(Matrix4.identity());

  ValueNotifier get getNotifierPicture => notifierPicture;

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

  String _title;
  String _body;

  String get getTitle => _title;
  String get getBody => _body;

  String _decorationImageUrl;
  String get getDecorationImageUrl => _decorationImageUrl;

  bool _isRemoveEnabled = false;
  bool get getRemoveEnabled => _isRemoveEnabled;

  bool _isFirstText = true;
  bool get getFirstEnabledText => _isFirstText;

  FontWeight _fontWeightFirst = FontWeight.normal;
  FontWeight get getCustomTextWeightFirst => _fontWeightFirst;

  FontWeight _fontWeightSecond = FontWeight.normal;
  FontWeight get getCustomTextWeightSecond => _fontWeightSecond;

  Color _colorFirstText = AppStyle.colorRed;
  Color get getTextColorFirst => _colorFirstText;

  Color _colorSecondText = AppStyle.colorRed;
  Color get getTextColorSecond => _colorSecondText;

  List<double> _fontSizesTitle = [22, 32, 42];
  List<double> _fontSizesBody = [12, 16, 20];

  double _titleFontSize = 22;
  double get getTitleFontSize => _titleFontSize;

  double _bodyFontSize = 12;
  double get getBodyFontSize => _bodyFontSize;

  double _titleTextBaseFontSize = 22;
  double get getTitleTextBaseFontSize => _titleTextBaseFontSize;

  double _bodyTextBaseFontSize = 12;
  double get getBodyTextBaseFontSize => _bodyTextBaseFontSize;

  int _indexFontSizeTitle = 0;
  int _indexFontSizebody = 0;
  int _indexTextBaseFontSizebody = 0;

  setImageSticker(String val) {
    this._imageUrl = val;
    notifyListeners();
  }

  setOffsetText(Offset _offset) {
    this.offset = _offset;
    notifyListeners();
  }

  setFontSize() {
    log('$_indexFontSizeTitle');
    log('$_indexFontSizebody');

    if (_isFirstText) {
      _indexFontSizeTitle++;

      if (_indexFontSizeTitle < _fontSizesTitle.length) {
        _titleFontSize = _fontSizesTitle[_indexFontSizeTitle];
      } else {
        _indexFontSizeTitle = 0;
        _titleFontSize = 22;
      }
    } else if (!_isFirstText) {
      _indexFontSizebody++;
      if (_indexFontSizebody < _fontSizesBody.length) {
        _bodyFontSize = _fontSizesBody[_indexFontSizebody];
      } else {
        _indexFontSizebody = 0;
        _bodyFontSize = 12;
      }
    }

    notifyListeners();
  }

  setTextBaseFontSize() {
    _indexTextBaseFontSizebody++;
    if (_indexTextBaseFontSizebody < _fontSizesTitle.length) {
      _titleTextBaseFontSize = _fontSizesTitle[_indexTextBaseFontSizebody];
      _bodyTextBaseFontSize = _fontSizesBody[_indexTextBaseFontSizebody];
    } else {
      _indexTextBaseFontSizebody = 0;
      _titleTextBaseFontSize = 22;
      _bodyTextBaseFontSize = 12;
    }
    notifyListeners();
  }

  removeFontSize() {
    _textAlign = CrossAxisAlignment.start;
    _align = TextAlign.start;
    notifyListeners();
  }

  setTextFieldEnable(bool val) {
    this._isFirstText = val;
  }

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
    this._fontWeightFirst = FontWeight.normal;
    this._fontWeightSecond = FontWeight.normal;
    this._titleFontSize = 22;
    this._bodyFontSize = 12;
    this._titleTextBaseFontSize = 22;
    this._bodyTextBaseFontSize = 12;
    this._colorFirstText = AppStyle.colorRed;
    this._colorSecondText = AppStyle.colorRed;
    _textAlign = CrossAxisAlignment.start;
    _align = TextAlign.start;
    offset = Offset(50, 100);
    setSavingState(false);

    notifyListeners();
  }

  setStoryBackgroundColor(Color valueColor) {
    this._backgColor = valueColor;
    if (valueColor == AppStyle.colorRed) {
      this._colorFirstText = AppStyle.colorDark;
      this._colorSecondText = AppStyle.colorDark;
      this._color = AppStyle.colorDark;
    } else {
      this._colorFirstText = AppStyle.colorRed;
      this._colorSecondText = AppStyle.colorRed;
      this._color = AppStyle.colorRed;
    }
    notifyListeners();
  }

  void setClearStoryData() {
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
    this._fontWeightFirst = FontWeight.normal;
    this._fontWeightSecond = FontWeight.normal;
    this._isRemoveEnabled = false;
    this._isLoading = false;
    this._backgColor = Colors.white;
    this._decorationImageUrl = null;
    this._titleFontSize = 22;
    this._bodyFontSize = 12;
    this._titleTextBaseFontSize = 22;
    this._bodyTextBaseFontSize = 12;
    this._colorFirstText = AppStyle.colorRed;
    this._colorSecondText = AppStyle.colorRed;
    offset = Offset(50, 100);
    this._childrenStickers.clear();
    this._imageUrl = null;
    this._indexFontSizeTitle = 0;
    this._indexFontSizebody = 0;
    setSavingState(false);
    log('all data cleared');
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
    if (_isFirstText) {
      if (_colorFirstText == AppStyle.colorRed)
        _colorFirstText = AppStyle.colorDark;
      else
        _colorFirstText = AppStyle.colorRed;
    } else if (!_isFirstText) {
      if (_colorSecondText == AppStyle.colorRed)
        _colorSecondText = AppStyle.colorDark;
      else
        _colorSecondText = AppStyle.colorRed;
    }

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
    if (_isFirstText) {
      this._fontWeightFirst = this._fontWeightFirst == FontWeight.normal
          ? FontWeight.bold
          : FontWeight.normal;
    } else if (!_isFirstText) {
      this._fontWeightSecond = this._fontWeightSecond == FontWeight.normal
          ? FontWeight.bold
          : FontWeight.normal;
    }
    notifyListeners();
  }

  setTitleBodyString(String title, String body) {
    this._title = title;
    this._body = body;
    notifyListeners();
  }

  setDecorationImage(String url) {
    this._decorationImageUrl = url;
    notifyListeners();
  }

  @override
  void dispose() {
    _stream?.close();
    streamController?.close();
    super.dispose();
  }

  setWidgetChildren(Widget widget) {
    this._childrenStickers.add(widget);
    notifyListeners();
  }

  removeLastWidgetChildren() {
    this._childrenStickers.removeLast();
    notifyListeners();
  }

  // List<Map<int, dynamic>> imageWidgetPosition = List<Map<int, dynamic>>();
  // setPositionOfWidget(val, ValueNotifier<Matrix4> pos) {
  //   this.imageWidgetPosition[val].addAll({val: pos});
  // }

  Future<ui.Image> getUiImage(
      Uint8List imageAssetPath, int height, int width) async {
    image.Image baseSizeImage = image.decodeImage(imageAssetPath);
    image.Image resizeImage =
        image.copyResize(baseSizeImage, height: height, width: width);
    ui.Codec codec =
        await ui.instantiateImageCodec(image.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    return frameInfo.image;
  }

  setSavingState(bool val) {
    streamController.sink.add(val);
  }
}
