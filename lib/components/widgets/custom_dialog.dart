import 'dart:ui';

import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomActionDialog extends StatelessWidget {
  final String title;
  final Function onPressed;
  final String cancelOptionText;
  final DialogType dialogType;
  final bool isIos;
  final bool isSuccess;
  final Color color;
  final String confirmOptionText;

  CustomActionDialog({
    @required this.title,
    @required this.onPressed,
    @required this.dialogType,
    this.color,
    this.cancelOptionText,
    this.isSuccess,
    this.isIos,
    this.confirmOptionText,
  });

  @override
  Widget build(BuildContext context) {
    return _setWidgetDialog(isIos, context, dialogType);
  }

  Widget _setWidgetDialog(bool isIo, BuildContext context, DialogType val) {
    switch (isIos) {
      case true:
        return _setCupertinoDialogType(val, context);
        break;
      case false:
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          child: _setMaterialDialogType(val, context),
        );
        break;
      default:
        return null;
    }
  }

  Widget _setMaterialDialogType(DialogType val, BuildContext context) {
    switch (val) {
      case DialogType.AlertDialog:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                this.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.red[100],
                    onPressed: onPressed,
                    child: Text(
                      'Да',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.green[100],
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Нет',
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
        break;
      case DialogType.InfoDialog:
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              isSuccess
                  ? "Картинка успешна сохранена!"
                  : "Ошибка при сохранении картинки!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    isSuccess
                        ? "Можете посмотреть в галерее."
                        : "Повторите еще раз попытку, проверьте доступ.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                FlatButton(
                  color: Colors.green[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Ok',
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  onPressed: onPressed,
                ),
              ],
            ),
          ]),
        );
        break;
      case DialogType.LoadingDialog:
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(
              "Загрузка...",
              textAlign: TextAlign.center,
            ),
          ]),
        );
        break;
      default:
        return const SizedBox();
    }
  }

  Widget _setCupertinoDialogType(DialogType val, BuildContext context) {
    switch (val) {
      case DialogType.AlertDialog:
        return CupertinoAlertDialog(
          title: Text(
            this.title,
            style: TextStyle(
              fontFamily: 'SF Pro Display',
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              isDestructiveAction: true,
              child: Text(
                "Да",
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                ),
              ),
              onPressed: onPressed,
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                "Нет",
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
        break;
      case DialogType.InfoDialog:
        return CupertinoAlertDialog(
          title: Text(
            isSuccess
                ? "Картинка успешна сохранена!"
                : "Ошибка при сохранении картинки!",
            style: TextStyle(
              fontFamily: 'SF Pro Display',
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Text(
              isSuccess
                  ? "Можете посмотреть в галерее."
                  : "Повторите попытку еще раз, проверьте доступ.",
              style: TextStyle(
                letterSpacing: 0.5,
                fontFamily: 'SF Pro Display',
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(
                "ОK",
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                ),
              ),
              onPressed: onPressed,
            ),
          ],
        );
        break;
      default:
        return null;
    }
  }
}
