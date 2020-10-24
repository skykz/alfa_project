import 'package:flutter/material.dart';

class HomeBloc extends ChangeNotifier {
  bool _isStoryTemplate = false;
  bool get getIsStoryTemplate => this._isStoryTemplate;

  setTypeOfAlfa(bool val) {
    this._isStoryTemplate = val;
    notifyListeners();
  }
}
