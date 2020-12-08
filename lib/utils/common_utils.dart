import 'dart:io';

import 'package:alfa_project/components/widgets/custom_dialog.dart';
import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:flutter/cupertino.dart';
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
          label: 'ok',
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
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
}

Future<bool> displayCustomDialog(
  BuildContext context,
  String _title,
  DialogType dialogType,
  bool barrierDismissible,
  bool isSuccess,
  Function dofunc, [
  String negativeText,
  String positiveText,
]) {
  return Platform.isAndroid
      ? showDialog(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (context) => CustomActionDialog(
            title: _title,
            dialogType: dialogType,
            onPressed: dofunc,
            isSuccess: isSuccess,
            isIos: false,
            cancelOptionText: negativeText,
            confirmOptionText: positiveText,
          ),
        )
      : showCupertinoDialog(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (context) => CustomActionDialog(
                title: _title,
                dialogType: dialogType,
                isSuccess: isSuccess,
                onPressed: dofunc,
                isIos: true,
                cancelOptionText: negativeText,
                confirmOptionText: positiveText,
              ));
}
