import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/search/search_image_text.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../../app.dart';

class CreateEditTemplateScreen extends StatefulWidget {
  final ImageProvider<dynamic> imageProvider;
  final String title;
  final String text;
  CreateEditTemplateScreen({
    this.imageProvider,
    this.title,
    this.text,
  });

  @override
  _CreateEditTemplateScreenState createState() =>
      _CreateEditTemplateScreenState();
}

class _CreateEditTemplateScreenState extends State<CreateEditTemplateScreen> {
  _goBack() {
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);
    storyBloc.setClearStoryData();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  GlobalKey globalKey = GlobalKey();
  double _value;
  // double widthTextContainer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _value = MediaQuery.of(context).size.width;
    });
  }

  @override
  Widget build(BuildContext context) {
    final storyBloc = Provider.of<StoryBloc>(context, listen: true);

    return WillPopScope(
      onWillPop: () async => displayCustomDialog(
          context,
          "Вы точно хотите покинуть эту страницу?\n",
          DialogType.AlertDialog,
          true,
          null,
          _goBack),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: false,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Stack(
              children: [
                RepaintBoundary(
                  key: globalKey,
                  child: Container(
                    color: storyBloc.getBackColor,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        MatrixGestureDetector(
                          shouldRotate: !storyBloc.getImagePositionState,
                          shouldScale: !storyBloc.getImagePositionState,
                          shouldTranslate: !storyBloc.getImagePositionState,
                          onMatrixUpdate: (m, tm, sm, rm) {
                            storyBloc.notifierPicture.value = m;
                          },
                          child: !storyBloc.getImagePositionState
                              ? AnimatedBuilder(
                                  animation: storyBloc.notifierPicture,
                                  builder: (ctx, child) {
                                    return Transform(
                                      transform:
                                          storyBloc.notifierPicture.value,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          Image(image: widget.imageProvider),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : StreamBuilder(
                                  stream: storyBloc.getPosition,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    return Transform(
                                      transform:
                                          storyBloc.getCurrenImagePosition,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          Image(image: widget.imageProvider),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        storyBloc.getTextEnabled
                            ? Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 100, bottom: 100),
                                child: Stack(
                                  children: [
                                    IgnorePointer(
                                      ignoring: storyBloc.getTextPositionSaved,
                                      child: MatrixGestureDetector(
                                        onMatrixUpdate: (m, tm, sm, rm) {
                                          storyBloc.notifierText.value = m;
                                        },
                                        child: AnimatedBuilder(
                                          animation: storyBloc.notifierText,
                                          builder: (ctx, child) {
                                            return Transform(
                                              transform:
                                                  storyBloc.notifierText.value,
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 30,
                                                    left: storyBloc
                                                            .textWidthContainer *
                                                        0.5,
                                                    right: storyBloc
                                                            .textWidthContainer *
                                                        0.5,
                                                    child: DottedBorder(
                                                      color: Colors.grey,
                                                      strokeWidth: 2,
                                                      dashPattern: [10, 4],
                                                      radius:
                                                          Radius.circular(1),
                                                      strokeCap:
                                                          StrokeCap.round,
                                                      child: Container(
                                                        child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                storyBloc
                                                                    .getTextAlignment,
                                                            children: [
                                                              TextField(
                                                                cursorRadius:
                                                                    Radius
                                                                        .circular(
                                                                            3),
                                                                textAlign:
                                                                    storyBloc
                                                                        .getAlign,
                                                                style:
                                                                    TextStyle(
                                                                  color: storyBloc
                                                                      .getTextColor,
                                                                  fontSize: 22,
                                                                ),
                                                                maxLines: null,
                                                                cursorColor:
                                                                    AppStyle
                                                                        .colorRed,
                                                                decoration:
                                                                    InputDecoration(
                                                                  fillColor:
                                                                      Colors
                                                                          .blue,
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Первая поля',
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          400]),
                                                                  helperStyle:
                                                                      TextStyle(
                                                                    color: storyBloc
                                                                        .getTextColor
                                                                        .withOpacity(
                                                                            0.3),
                                                                  ),
                                                                ),
                                                              ),
                                                              TextField(
                                                                cursorRadius:
                                                                    Radius
                                                                        .circular(
                                                                            3),
                                                                textAlign:
                                                                    storyBloc
                                                                        .getAlign,
                                                                maxLines: null,
                                                                style:
                                                                    TextStyle(
                                                                  color: storyBloc
                                                                      .getTextColor,
                                                                  fontSize: 22,
                                                                ),
                                                                cursorColor:
                                                                    AppStyle
                                                                        .colorRed,
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      InputBorder
                                                                          .none,
                                                                  hintText:
                                                                      'Второя поля',
                                                                  hintStyle: TextStyle(
                                                                      color: Colors
                                                                              .grey[
                                                                          400]),
                                                                  helperStyle:
                                                                      TextStyle(
                                                                    color: storyBloc
                                                                        .getTextColor
                                                                        .withOpacity(
                                                                            0.3),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) =>
                            ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: storyBloc.getTextEnabled
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: BounceButton(
                                      isShadow: true,
                                      onPressed: () {},
                                      iconImagePath: SvgIconsClass.libraryIcon,
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      'База\nтекстов',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppStyle.colorDark,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: BounceButton(
                                      isShadow: true,
                                      onPressed: () {
                                        storyBloc.setTextEnabled(
                                            storyBloc.getTextEnabled
                                                ? false
                                                : true);
                                      },
                                      iconImagePath:
                                          SvgIconsClass.textSelectIcon,
                                    ),
                                  ),
                                  FittedBox(
                                    child: Text(
                                      'Размер\nшрифта',
                                      style: TextStyle(
                                        color: AppStyle.colorDark,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: BounceButton(
                                      isShadow: true,
                                      onPressed: () {
                                        storyBloc.setTextAlign();
                                      },
                                      iconImagePath:
                                          SvgIconsClass.textAlignIcon,
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.cover,
                                    child: Text(
                                      'Вырав\nнивание',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppStyle.colorDark,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: BounceButton(
                                      isShadow: true,
                                      onPressed: () {
                                        storyBloc.setTextColor();
                                      },
                                      iconImagePath:
                                          SvgIconsClass.fillColorIcon,
                                    ),
                                  ),
                                  Text(
                                    'Цвет\nшрифта',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppStyle.colorDark,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 35,
                                    child: BounceButton(
                                      isShadow: true,
                                      onPressed: () {},
                                      iconImagePath: SvgIconsClass.boldIcon,
                                    ),
                                  ),
                                  Text(
                                    'Толщина\nшрифта',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppStyle.colorDark,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    width: 32,
                                    child: BounceButton(
                                      isShadow: true,
                                      onPressed: () => displayCustomDialog(
                                          context,
                                          "Вы точно хотите покинуть эту страницу?\n",
                                          DialogType.AlertDialog,
                                          true,
                                          null,
                                          _goBack),
                                      iconImagePath: SvgIconsClass.closeIcon,
                                    ),
                                  ),
                                  Text(
                                    'Удалить',
                                    style: TextStyle(
                                      fontSize: 10,
                                      height: 2,
                                      fontWeight: FontWeight.w300,
                                      color: AppStyle.colorDark,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                ),
                storyBloc.getTextEnabled
                    ? const SizedBox()
                    : storyBloc.getImagePositionState
                        ? Positioned(
                            top: 10,
                            left: 10,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: BounceButton(
                                    isShadow: true,
                                    onPressed: () => displayCustomDialog(
                                        context,
                                        "Вы точно хотите покинуть эту страницу?\n",
                                        DialogType.AlertDialog,
                                        true,
                                        null,
                                        _goBack),
                                    iconImagePath: SvgIconsClass.closeIcon,
                                  ),
                                ),
                                const Text(
                                  'Закрыть',
                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87,
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                storyBloc.getTextEnabled
                    ? const SizedBox()
                    : !storyBloc.getImagePositionState
                        ? Positioned(
                            top: 10,
                            right: 10,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: BounceButton(
                                    isShadow: true,
                                    onPressed: () {
                                      storyBloc.setClearStoryData();
                                      Navigator.pop(context);
                                    },
                                    iconImagePath: SvgIconsClass.closeIcon,
                                  ),
                                ),
                                Text(
                                  'Закрыть',
                                  style: TextStyle(
                                    height: 1.5,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black87,
                                  ),
                                )
                              ],
                            ),
                          )
                        : Positioned(
                            top: 10,
                            right: 10,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: BounceButton(
                                          isShadow: true,
                                          onPressed: () {
                                            storyBloc.setTextEnabled(true);
                                          },
                                          iconImagePath:
                                              SvgIconsClass.textSizeIcon,
                                        ),
                                      ),
                                      Text(
                                        'Текст',
                                        style: TextStyle(
                                          height: 1.1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: BounceButton(
                                          isShadow: true,
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchPickerScreen(
                                                  isText: false,
                                                ),
                                              ),
                                            );
                                          },
                                          iconImagePath:
                                              SvgIconsClass.stickerIcon,
                                        ),
                                      ),
                                      Text(
                                        'Стикеры',
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.5,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                !storyBloc.getTextEnabled
                    ? storyBloc.getImagePositionState
                        ? Positioned(
                            bottom: 20,
                            right: 10,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: BounceButton(
                                    isShadow: true,
                                    onPressed: _capturePng,
                                    iconImagePath: SvgIconsClass.saveIcon,
                                  ),
                                ),
                                Text(
                                  'Сохранить',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: AppStyle.colorDark,
                                  ),
                                )
                              ],
                            ))
                        : Positioned(
                            bottom: 20,
                            right: 10,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: BounceButton(
                                    isShadow: true,
                                    onPressed: () {
                                      storyBloc.setImagePositionState(true);
                                    },
                                    iconImagePath: SvgIconsClass.doneIcon,
                                  ),
                                ),
                                Text(
                                  'Готово',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: AppStyle.colorDark,
                                  ),
                                )
                              ],
                            ),
                          )
                    : storyBloc.getTextPositionSaved
                        ? Positioned(
                            bottom: 20,
                            right: 10,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: BounceButton(
                                    isShadow: true,
                                    onPressed: _capturePng,
                                    iconImagePath: SvgIconsClass.saveIcon,
                                  ),
                                ),
                                Text(
                                  'Сохранить',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: AppStyle.colorDark,
                                  ),
                                )
                              ],
                            ),
                          )
                        : Positioned(
                            bottom: 20,
                            right: 10,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: BounceButton(
                                    isShadow: true,
                                    onPressed: () {
                                      storyBloc.setTextPosition(true);
                                    },
                                    iconImagePath: SvgIconsClass.doneIcon,
                                  ),
                                ),
                                Text(
                                  'Готово',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w300,
                                    color: AppStyle.colorDark,
                                  ),
                                )
                              ],
                            ),
                          ),
                storyBloc.getImagePositionState
                    ? Positioned(
                        bottom: 20,
                        left: 10,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 35,
                              width: 35,
                              child: BounceButton(
                                isShadow: true,
                                onPressed: () {
                                  storyBloc.setUndoState(false);
                                },
                                iconImagePath: SvgIconsClass.undoIcon,
                              ),
                            ),
                            Text(
                              'Вернуть',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                color: AppStyle.colorDark,
                              ),
                            )
                          ],
                        ),
                      )
                    : const SizedBox(),
                storyBloc.getTextEnabled
                    ? storyBloc.getTextPositionSaved
                        ? const SizedBox()
                        : Positioned(
                            bottom: 50,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.5),
                                  blurRadius: 10,
                                ),
                              ]),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    thumbShape: RoundSliderThumbShape()),
                                child: Slider(
                                  value: storyBloc.textWidthContainer,
                                  // min: 10,
                                  max: _value,
                                  // divisions: 100,
                                  onChanged: (newValue) {
                                    storyBloc.setTextWidthContainer(newValue);
                                  },
                                ),
                              ),
                            ),
                          )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _capturePng() {
    return new Future.delayed(const Duration(milliseconds: 25), () async {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      // print(pngBytes);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File("$dir/" +
          'AlfaStory' +
          "${DateTime.now().millisecondsSinceEpoch}" +
          ".png");
      await file.writeAsBytes(pngBytes);
      log('${file.path}');

      GallerySaver.saveImage(file.path).then((value) => displayCustomDialog(
            context,
            null,
            DialogType.InfoDialog,
            false,
            value,
            _goToInitialHome,
          ));
    });
  }

  _goToInitialHome() {
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(pageBuilder: (BuildContext context,
            Animation animation, Animation secondaryAnimation) {
          return MyApp();
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        }),
        (Route route) => false);
  }
}
