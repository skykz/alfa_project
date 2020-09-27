import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/screens/home/select_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          'Авторизуйтесь',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppStyle.colorDark,
          ),
        ),
        elevation: 15,
        shadowColor: Colors.grey[200],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/svg/logo.svg'),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            'льфа Дизайн',
                            style: TextStyle(
                              letterSpacing: 1.5,
                              fontSize: 30,
                              color: AppStyle.colorRed,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            TextField(
                              cursorColor: AppStyle.colorDark,
                              decoration: InputDecoration(
                                hintText: "Введи почту",
                                labelText: "Почта",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelStyle: TextStyle(
                                  color: const Color(0xFF424242),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyle.colorDark,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppStyle.colorDark,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              cursorColor: AppStyle.colorDark,
                              decoration: InputDecoration(
                                hintText: "Введи пароль",
                                labelText: "Пароль",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelStyle: TextStyle(
                                  color: const Color(0xFF424242),
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyle.colorDark,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: AppStyle.colorDark,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              value: _isChecked,
                              onChanged: (val) {
                                setState(() {
                                  _isChecked = val;
                                });
                              },
                              activeColor: Colors.red,
                              checkColor: Colors.white,
                            ),
                            Text(
                              'Запомнить меня',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 30),
                    child: FlatButton(
                      color: AppStyle.colorRed,
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectTypeTemplate(),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            'Войти',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  // double _scaleFactor = 1.0;
  // double _baseScaleFactor = 1.0;
  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //       child: GestureDetector(
  //     onScaleStart: (details) {
  //       _baseScaleFactor = _scaleFactor;
  //     },
  //     onScaleUpdate: (details) {
  //       setState(() {
  //         _scaleFactor = _baseScaleFactor * details.scale;
  //       });
  //     },
  //     child: Container(
  //       height: MediaQuery.of(context).size.height,
  //       width: MediaQuery.of(context).size.width,
  //       color: Colors.red,
  //       child: Center(
  //         child: Text(
  //           'Test',
  //           textScaleFactor: _scaleFactor,
  //         ),
  //       ),
  //     ),
  //   ));
  // }
}
