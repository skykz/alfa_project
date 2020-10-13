import 'package:flutter/material.dart';

class CardGeneralWidget extends StatelessWidget {
  final String imageAsset;
  final String title;
  final Color colorMain;
  final Color colorText;

  final Color shadowColor;

  const CardGeneralWidget(
      {Key key,
      this.imageAsset,
      this.title,
      this.colorMain,
      this.shadowColor,
      this.colorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          color: colorMain,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 10,
              color: shadowColor,
            ),
          ]),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              imageAsset,
              width: 260,
              fit: BoxFit.contain,
              // height: 100,
            ),
          ),
          Positioned(
            top: 40,
            left: 18,
            bottom: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Text(
                title,
                style: TextStyle(
                  color: colorText,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
