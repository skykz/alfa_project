import 'package:flutter/material.dart';

class CreateEditTemplateScreen extends StatefulWidget {
  final bool isText;
  CreateEditTemplateScreen({Key key, this.isText}) : super(key: key);

  @override
  _CreateEditTemplateScreenState createState() =>
      _CreateEditTemplateScreenState();
}

class _CreateEditTemplateScreenState extends State<CreateEditTemplateScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    color: Colors.red,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    color: Colors.red,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    color: Colors.red,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    color: Colors.red,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
