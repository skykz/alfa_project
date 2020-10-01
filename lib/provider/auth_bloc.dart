import 'dart:developer';

import 'package:alfa_project/core/repository/api_repository.dart';
import 'package:alfa_project/screens/home/select_type.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  AlfaApi _alfaApi = AlfaApi();

  setLoadingState(bool val) {
    this._isLoading = val;
    notifyListeners();
  }

  authLogin(String email, String password, BuildContext context) {
    setLoadingState(true);
    _alfaApi.authLogin(email, password, context).then((value) {
      if (value != null) {
        setLocalToken('token', value);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SelectTypeTemplate(),
          ),
        );
      }
    }).whenComplete(
      () => setLoadingState(false),
    );
  }

  authReminder(bool val) {
    setLocalPrefs('isReminder', val);
  }

  setLocalPrefs(String key, bool val) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setBool(key, val);
  }

  setLocalToken(String key, String val) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key, val);
  }
}
