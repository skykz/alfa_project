import 'dart:developer';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/provider/auth_bloc.dart';
import 'package:alfa_project/provider/search_text_image.dart';
import 'package:alfa_project/screens/auth/login_screen.dart';
import 'package:alfa_project/screens/home/select_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        ChangeNotifierProvider<SearchTextImageBloc>(
          create: (context) => SearchTextImageBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.red,
          platform: TargetPlatform.iOS,
          scaffoldBackgroundColor: AppStyle.mainbgColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: FutureBuilder(
            future: SharedPreferences.getInstance(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.data == null)
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              bool isLogged = snapshot.data.getBool('isReminder') ?? false;
              log("$isLogged");
              if (isLogged)
                return SelectTypeTemplate();
              else
                return LoginScreen();
            }),
      ),
    );
  }
}
