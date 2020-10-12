import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:flutter/material.dart';

class CustomActionDialog extends StatelessWidget {
  final String title;
  final Function onPressed;
  final String cancelOptionText;
  final DialogType dialogType;
  final Color color;
  final String confirmOptionText;

  CustomActionDialog({
    @required this.title,
    @required this.onPressed,
    @required this.dialogType,
    this.color,
    this.cancelOptionText,
    this.confirmOptionText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: _setDialogType(dialogType, context),
    );
  }

  Widget _setDialogType(DialogType val, BuildContext context) {
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
                    color: Colors.red[300],
                    onPressed: onPressed,
                    child: Text(
                      'Да',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: Colors.green[300],
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Нет',
                      style: TextStyle(
                        color: Colors.white,
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    this.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Theme(
                  data: ThemeData(
                    highlightColor: Colors.grey[300],
                  ),
                  child: Container(
                    color: (index % 2 == 0) ? Colors.white : Colors.grey[100],
                    child: Material(
                      color: Colors.transparent,
                      child: ListTile(
                        onTap: () {},
                        title: Text(
                          "${index + 1}. название",
                          style: TextStyle(),
                        ),
                        trailing: const SizedBox(
                          width: 10,
                          child: Center(
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black54,
                              size: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
        break;
      default:
        return const SizedBox();
    }
  }
}
