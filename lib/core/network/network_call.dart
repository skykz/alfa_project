import 'dart:developer';
import 'dart:io';

import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkCall {
  // next three lines makes this class a Singleton
  static NetworkCall _instance = NetworkCall.internal();

  NetworkCall.internal();
  factory NetworkCall() => _instance;

  Future<dynamic> doRequestAuth(
      {@required String path,
      @required String method,
      @required BuildContext context,
      Map<String, dynamic> requestParams,
      Map<String, dynamic> body,
      FormData formData}) async {
    BaseOptions options = BaseOptions(
        baseUrl: BASE_URL, //base server url
        method: method,
        contentType: ContentType.parse("application/json").value);

    Dio dio = Dio(options);
    Response response;

    try {
      response =
          await dio.request(path, queryParameters: requestParams, data: body);

      log(" - Response - ", name: " api route -- $path");

      return response.data.toString();
    } on DioError catch (error) {
      handleError(error, context);
    }
  }

  Future<dynamic> doRequestMain({
    @required String path,
    @required String method,
    @required BuildContext context,
    Map<String, dynamic> requestParams,
    Map<String, dynamic> body,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String accessToken = sharedPreferences.getString("token");

    BaseOptions options = BaseOptions(
      baseUrl: BASE_URL,
      // connectTimeout:10000, // 10 sec.
      // receiveTimeout:10000,
      method: method,
      headers: {'Authorization': 'Bearer ' + accessToken},
      contentType: 'application/json',
    );

    Dio dio = Dio(options);
    Response response;

    try {
      log(" - Response - ", name: " api route -- $BASE_URL $path");
      response =
          await dio.request(path, queryParameters: requestParams, data: body);

      print(" +++++ ${response.data}");
      return response.data;
    } on DioError catch (error) {
      print(' --- req main errors +++++++++ $error');
      handleError(error, context);
    }
  }
}

/// handling avaiable cases from server
void handleError(DioError error, BuildContext context) {
  String errorDescription;

  if (error is DioError) {
    switch (error.type) {
      case DioErrorType.CANCEL:
        errorDescription = 'Запрос был отменен';
        print(errorDescription);

        break;
      case DioErrorType.CONNECT_TIMEOUT:
        errorDescription = 'Попробуйте позже или перезагрузите';
        print(errorDescription);

        break;
      case DioErrorType.DEFAULT:
        errorDescription = 'Интернет-желі табылмады';
        print(errorDescription);

        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        errorDescription = 'Время ожидание ответа сервера истекло';
        print(errorDescription);

        break;
      case DioErrorType.RESPONSE:
        errorDescription = "Неверные данные: Почта или пароль";
        print(errorDescription);

        break;
      case DioErrorType.SEND_TIMEOUT:
        errorDescription = 'Время соединения истекло';
        print(errorDescription);
        break;
    }
  }

  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: Duration(seconds: 20),
        backgroundColor: Colors.red[600],
        action: SnackBarAction(
          label: 'ОК',
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  errorDescription,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
