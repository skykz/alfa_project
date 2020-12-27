import 'package:alfa_project/core/repository/api_repository.dart';
import 'package:flutter/material.dart';

class SearchTextImageBloc extends ChangeNotifier {
  AlfaApi _alfaApi = AlfaApi();
  List<dynamic> _textList = List();
  dynamic get getSearchText => _textList;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  setLoadingState(bool val) {
    this._isLoading = val;
    notifyListeners();
  }

  Future getCategories() async {
    return await _alfaApi.getCategory();
  }

  Future getTextBase() async {
    return await _alfaApi.getText();
  }

  Future getImages(int catId, BuildContext context) async {
    return await _alfaApi.getImage(catId, context);
  }

  setSearchedData(dynamic val) {
    this._textList = val;
    notifyListeners();
  }

  searchText(String query, BuildContext context) async {
    setLoadingState(true);
    _alfaApi.getSearchText(query.trim(), context).then((value) {
      if (value != null) setSearchedData(value);
    }).whenComplete(() => setLoadingState(false));
  }

  setClearData() {
    this._textList = List();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    this._textList = List();
  }
}
