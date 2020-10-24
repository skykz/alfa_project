import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BounceButton extends StatefulWidget {
  final SvgPicture iconImagePath;
  final Function onPressed;
  final Icon icon;
  final bool isShadow;

  const BounceButton({
    Key key,
    this.iconImagePath,
    this.icon,
    this.isShadow = false,
    @required this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BounceButton();
}

class _BounceButton extends State<BounceButton>
    with TickerProviderStateMixin<BounceButton> {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 70),
      lowerBound: 0.0,
      upperBound: 0.3,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _controller.forward().then((val) {
          _controller.reverse().then((val) {
            widget.onPressed();
          });
        });
      },
      child: Transform.scale(
        scale: _scale,
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: widget.isShadow
                    ? [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ]
                    : []),
            child: widget.iconImagePath),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
