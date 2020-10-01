import 'package:flutter/material.dart';

void printWrapped(String text) {
  final pattern = new RegExp('.{1,900}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

void showCustomSnackBar(
    BuildContext context, String text, Color color, IconData iconData) {
  Scaffold.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 7),
        backgroundColor: color,
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.white,
          onPressed: () {},
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(iconData, color: Colors.white),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "$text",
                  style: TextStyle(color: Colors.white, fontFamily: 'Rubik'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
