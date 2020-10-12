import 'dart:core';

import 'package:alfa_project/core/network/network_call.dart';
import 'package:flutter/material.dart';

class AlfaApi {
  static AlfaApi _instance = AlfaApi.internal();
  AlfaApi.internal();
  factory AlfaApi() => _instance;

  NetworkCall _networkCall = NetworkCall();

  // Auth API
  static const LOGIN = 'login';

  // get images from server
  static const GET_IMAGE = 'img';
  static const GET_LAST_IMAGE = 'img_last';

  // get text and search text from server
  static const GET_TEXT = 'text';
  static const SEARCH_TEXT = 'search_text';

  // get categories
  static const GET_CATEGORY = 'category';

  Future<String> authLogin(String email, String password,
      [BuildContext context]) async {
    String response = await _networkCall.doRequestAuth(
      path: LOGIN,
      method: 'POST',
      context: context,
      body: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  Future<dynamic> getCategory([BuildContext context]) async {
    dynamic response = await _networkCall.doRequestMain(
      path: GET_CATEGORY,
      method: 'GET',
      context: context,
    );
    return response;
  }

  Future<dynamic> getImage(int categoryId, [BuildContext context]) async {
    dynamic response = await _networkCall.doRequestMain(
      path: GET_IMAGE,
      method: 'GET',
      context: context,
      requestParams: {
        "category": "${categoryId.toString()}",
      },
    );
    return response;
  }

  Future<dynamic> getLastImage(String phoneNumber,
      [BuildContext context]) async {
    dynamic response = await _networkCall.doRequestMain(
      path: GET_LAST_IMAGE,
      method: 'GET',
      context: context,
    );
    return response;
  }

  Future<dynamic> getText([BuildContext context]) async {
    dynamic response = await _networkCall.doRequestMain(
      path: GET_TEXT,
      method: 'GET',
      context: context,
    );
    return response;
  }

  Future<dynamic> getSearchText(String query, [BuildContext context]) async {
    dynamic response = await _networkCall.doRequestMain(
        path: SEARCH_TEXT,
        method: 'GET',
        context: context,
        requestParams: {
          'query': query,
        });
    return response;
  }
}
