import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/provider/auth_bloc.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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
                            TextFormField(
                              cursorColor: AppStyle.colorDark,
                              controller: emailTextController,
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
                            TextFormField(
                              cursorColor: AppStyle.colorDark,
                              obscureText: true,
                              controller: passwordTextController,
                              decoration: InputDecoration(
                                hintText: "Введите пароль",
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
                                final authBloc = Provider.of<AuthBloc>(context,
                                    listen: false);
                                authBloc.authReminder(val);
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
                  Builder(
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 30),
                      child:
                          Consumer<AuthBloc>(builder: (context, bloc, child) {
                        return FlatButton(
                          color: AppStyle.colorRed,
                          onPressed: () => login(ctx),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: SizedBox(
                              height: 25,
                              width: double.infinity,
                              child: Center(
                                child: bloc.isLoading
                                    ? SizedBox(
                                        width: 25,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 1,
                                          backgroundColor: Colors.white,
                                        ),
                                      )
                                    : Text(
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
                        );
                      }),
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

  login(BuildContext context) {
    if (emailTextController.text.length > 0 &&
        passwordTextController.text.length > 0) {
      bool emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailTextController.text);
      if (emailValid) {
        final authBloc = Provider.of<AuthBloc>(context, listen: false);
        authBloc.authLogin(emailTextController.text.trim(),
            passwordTextController.text.trim(), context);
      } else {
        showCustomSnackBar(context, 'Неверный формат почты', AppStyle.colorRed,
            Icons.info_outline);
      }
    }
  }
}
