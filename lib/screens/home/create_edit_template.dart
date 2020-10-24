import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:alfa_project/provider/home_bloc.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/search/picker_image_text.dart';
import 'package:alfa_project/screens/search/search_image_text.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:vector_math/vector_math_64.dart' as vector;

import '../../app.dart';

class CreateEditTemplateScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String text;
  CreateEditTemplateScreen({
    this.imageUrl,
    this.title,
    this.text,
  });

  @override
  _CreateEditTemplateScreenState createState() =>
      _CreateEditTemplateScreenState();
}

class _CreateEditTemplateScreenState extends State<CreateEditTemplateScreen> {
  GlobalKey globalKey = GlobalKey();
  double _value;
  // Matrix4 matrix;
  // ValueNotifier<Matrix4> notifier;
  Boxer boxer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _value = MediaQuery.of(context).size.width;
    });
    // notifier = ValueNotifier(matrix);
  }

  _goBack() {
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);
    storyBloc.setClearStoryData();
    Navigator.of(context, rootNavigator: true).pop();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
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
          body: widget.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: BASE_URL_IMAGE + widget.imageUrl,
                  imageBuilder: (context, imageProvider) => GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: Stack(
                      children: [
                        RepaintBoundary(
                          key: globalKey,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              _buildMainImage(storyBloc, imageProvider),
                              _buildTextWidget(storyBloc),
                              _buildImageDecoration(storyBloc),
                            ],
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
                                ? storyBloc.getTitle == null
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 35,
                                                width: 35,
                                                child: BounceButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              SearchPickerScreen(
                                                            isText: true,
                                                          ),
                                                        ));
                                                  },
                                                  iconImagePath:
                                                      SvgIconsClass.libraryIcon,
                                                ),
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  'База',
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
                                                  onPressed: () {},
                                                  iconImagePath: SvgIconsClass
                                                      .textSelectIcon,
                                                ),
                                              ),
                                              FittedBox(
                                                child: Text(
                                                  'Размер',
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
                                                  onPressed: () {
                                                    storyBloc.setTextAlign();
                                                  },
                                                  iconImagePath: SvgIconsClass
                                                      .textAlignIcon,
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.cover,
                                                child: Text(
                                                  'Ровнять',
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
                                                  onPressed: () {
                                                    storyBloc.setTextColor();
                                                  },
                                                  iconImagePath: SvgIconsClass
                                                      .fillColorIcon,
                                                ),
                                              ),
                                              Text(
                                                'Цвет',
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
                                                  onPressed: () => storyBloc
                                                      .setFontCustomWeight(),
                                                  iconImagePath:
                                                      SvgIconsClass.boldIcon,
                                                ),
                                              ),
                                              Text(
                                                'Толщина',
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
                                                  onPressed: () =>
                                                      displayCustomDialog(
                                                          context,
                                                          "Вы точно хотите покинуть эту страницу?\n",
                                                          DialogType
                                                              .AlertDialog,
                                                          true,
                                                          null,
                                                          _goBack),
                                                  iconImagePath:
                                                      SvgIconsClass.closeIcon,
                                                ),
                                              ),
                                              Text(
                                                'Удалить',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w300,
                                                  color: AppStyle.colorDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(
                                                height: 35,
                                                width: 35,
                                                child: BounceButton(
                                                  onPressed: () {
                                                    storyBloc.setTextAlign();
                                                  },
                                                  iconImagePath: SvgIconsClass
                                                      .textAlignIcon,
                                                ),
                                              ),
                                              FittedBox(
                                                fit: BoxFit.cover,
                                                child: Text(
                                                  'Ровнять',
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
                                                  onPressed: () {
                                                    storyBloc.setTextColor();
                                                  },
                                                  iconImagePath: SvgIconsClass
                                                      .fillColorIcon,
                                                ),
                                              ),
                                              Text(
                                                'Цвет',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppStyle.colorDark,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              )
                                            ],
                                          ),
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 35,
                                                    width: 32,
                                                    child: BounceButton(
                                                      onPressed: () =>
                                                          displayCustomDialog(
                                                              context,
                                                              "Вы точно хотите покинуть эту страницу?\n",
                                                              DialogType
                                                                  .AlertDialog,
                                                              true,
                                                              null,
                                                              _goBack),
                                                      iconImagePath:
                                                          SvgIconsClass
                                                              .closeIcon,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Удалить',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: AppStyle.colorDark,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
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
                                            iconImagePath:
                                                SvgIconsClass.closeIcon,
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
                                            onPressed: () => displayCustomDialog(
                                                context,
                                                "Вы точно хотите покинуть эту страницу?\n",
                                                DialogType.AlertDialog,
                                                true,
                                                null,
                                                _goBack),
                                            iconImagePath:
                                                SvgIconsClass.closeIcon,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: BounceButton(
                                                  onPressed: () {
                                                    storyBloc
                                                        .setTextEnabled(true);
                                                  },
                                                  iconImagePath: SvgIconsClass
                                                      .textSizeIcon,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 40,
                                                width: 40,
                                                child: BounceButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            StickerTextPicker(
                                                          isDecoration: true,
                                                          isTextBase: false,
                                                          title: "",
                                                          text: "",
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
                        Positioned(
                          bottom: 20,
                          right: 10,
                          child: !storyBloc.getTextEnabled
                              ? storyBloc.getImagePositionState
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: BounceButton(
                                            onPressed: _capturePng,
                                            iconImagePath:
                                                SvgIconsClass.saveIcon,
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
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: BounceButton(
                                            onPressed: () {
                                              storyBloc
                                                  .setImagePositionState(true);
                                            },
                                            iconImagePath:
                                                SvgIconsClass.doneIcon,
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
                                    )
                              : storyBloc.getTextPositionSaved
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: BounceButton(
                                            onPressed: _capturePng,
                                            iconImagePath:
                                                SvgIconsClass.saveIcon,
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
                                    )
                                  : Column(
                                      children: [
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: BounceButton(
                                            onPressed: () {
                                              storyBloc.setTextPosition(true);
                                              FocusScope.of(context).unfocus();
                                            },
                                            iconImagePath:
                                                SvgIconsClass.doneIcon,
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
                                        onPressed: () {
                                          storyBloc.setUndoImageState(false);
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
                            ? Positioned(
                                bottom: 20,
                                left: 10,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 35,
                                      width: 35,
                                      child: BounceButton(
                                        onPressed: () {
                                          storyBloc.setUndoTextState(false);
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
                                    bottom: 80,
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
                                            thumbShape:
                                                RoundSliderThumbShape()),
                                        child: Slider(
                                          value: storyBloc.textWidthContainer,
                                          max: _value,
                                          min: 10,
                                          onChanged: (newValue) {
                                            storyBloc.setTextWidthContainer(
                                                newValue);
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  placeholder: (context, url) => Center(
                    child: !Platform.isAndroid
                        ? const CupertinoActivityIndicator(
                            radius: 15,
                          )
                        : SizedBox(
                            height: 25,
                            width: 25,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Colors.white,
                            ),
                          ),
                  ),
                  errorWidget: (context, url, error) => Column(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 25,
                      ),
                      Text('Проблема с интернетом!\nПроверьте интернет')
                    ],
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }

  Future<void> _capturePng() {
    final homeBloc = Provider.of<HomeBloc>(context, listen: false);

    return new Future.delayed(const Duration(milliseconds: 25), () async {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();

      ui.Image image = await boundary.toImage(pixelRatio: 3);

      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      Uint8List pngBytes = byteData.buffer.asUint8List();
      if (!homeBloc.getIsStoryTemplate) {
        ui.Image x = await decodeImageFromList(pngBytes);
        print('height is ${x.height}'); //height of original image
        print('width is ${x.width}'); //width of oroginal image
        ui.instantiateImageCodec(pngBytes, targetWidth: 1536).then((codec) {
          codec.getNextFrame().then((frameInfo) async {
            ui.Image i = frameInfo.image;
            print('image width is ${i.width}'); //height of resized image
            print('image height is ${i.height}'); //width of resized image
          });
        });
      }
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File("$dir/" +
          'AlfaStory' +
          "${DateTime.now().millisecondsSinceEpoch}" +
          ".png");
      await file.writeAsBytes(pngBytes);
      log('${file.path}');

      GallerySaver.saveImage(file.path).then((value) {
        log("$value");
        displayCustomDialog(
          context,
          null,
          DialogType.InfoDialog,
          false,
          value,
          _goToInitialHome,
        );
      });
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

  _buildMainImage(StoryBloc storyBloc, ImageProvider imageProvider) {
    return MatrixGestureDetector(
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
                  transform: storyBloc.notifierPicture.value,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image(image: imageProvider),
                    ],
                  ),
                );
              },
            )
          : StreamBuilder(
              stream: storyBloc.getPosition,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Transform(
                  transform: storyBloc.getCurrenImagePosition,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image(image: imageProvider),
                    ],
                  ),
                );
              },
            ),
    );
  }

  _buildTextWidget(StoryBloc storyBloc) {
    return storyBloc.getTextEnabled
        ? LayoutBuilder(builder: (ctx, constraints) {
            var width = constraints.biggest.width;
            var height = constraints.biggest.height / 3;
            var dx = (constraints.biggest.width - width) / 2.5;
            var dy = (constraints.biggest.height - height) / 2.5;
            log("== ${constraints.biggest}");

            log("== $width");
            log("== $height");
            log("== $dx");
            log("== $dy");
            log("== ${storyBloc.notifierText.value}");

            // storyBloc.notifierText.value.leftTranslate(dx, dy);
            boxer = Boxer(
                Offset(MediaQuery.of(context).size.width * 0.1,
                        MediaQuery.of(context).size.height * 0.1) &
                    Size(MediaQuery.of(context).size.width * 0.8,
                        MediaQuery.of(context).size.height * 0.85),
                Rect.fromLTWH(0, 0, width, height));

            return IgnorePointer(
              ignoring: storyBloc.getTextPositionSaved,
              child: MatrixGestureDetector(
                shouldRotate: false,
                // shouldScale: false,
                onMatrixUpdate: (m, tm, sm, rm) {
                  storyBloc.notifierText.value = MatrixGestureDetector.compose(
                      storyBloc.notifierText.value, tm, sm, null);
                  boxer.clamp(storyBloc.notifierText.value);
                  // notifier.value = matrix;
                  storyBloc.notifierText.value = storyBloc.notifierText.value;
                },
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  // color: Colors.deepPurple,
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    border: Border.all(
                      width: 0.5,
                      color: Colors.white,
                    ),
                  ),
                  child: AnimatedBuilder(
                    animation: storyBloc.notifierText,
                    builder: (ctx, child) {
                      return Transform(
                        transform: storyBloc.notifierText.value,
                        child: Column(
                          children: [
                            Container(
                              // height: height,
                              width: width,
                              child: Center(
                                child: Container(
                                  width: storyBloc.textWidthContainer,
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    border: Border.all(
                                      width: 0.5,
                                      color: storyBloc.getTextPositionSaved
                                          ? Colors.transparent
                                          : Color.fromRGBO(200, 203, 208, 1),
                                    ),
                                  ),
                                  child: Center(
                                    child: storyBloc.getTitle == null
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                storyBloc.getTextAlignment,
                                            children: [
                                                TextField(
                                                  cursorRadius:
                                                      Radius.circular(2),
                                                  textAlign: storyBloc.getAlign,
                                                  style: TextStyle(
                                                    color:
                                                        storyBloc.getTextColor,
                                                    fontSize: 22,
                                                    fontFamily: 'Styrene A LC',
                                                    fontWeight: storyBloc
                                                        .getCustomTextWeight,
                                                  ),
                                                  maxLines: null,
                                                  cursorColor:
                                                      AppStyle.colorRed,
                                                  decoration: InputDecoration(
                                                    fillColor: Colors.blue,
                                                    border: InputBorder.none,
                                                    hintText: storyBloc
                                                            .getTextPositionSaved
                                                        ? ''
                                                        : 'Напишите что-нибудь...',
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Colors.grey[400]),
                                                    helperStyle: TextStyle(
                                                      fontSize: 15,
                                                      color: storyBloc
                                                          .getTextColor
                                                          .withOpacity(0.3),
                                                    ),
                                                  ),
                                                ),
                                              ])
                                        : Column(
                                            crossAxisAlignment:
                                                storyBloc.getTextAlignment,
                                            children: [
                                              Text(
                                                storyBloc.getTitle,
                                                textAlign: storyBloc.getAlign,
                                                style: TextStyle(
                                                  color: storyBloc.getTextColor,
                                                  fontSize: 26,
                                                  fontFamily: 'Styrene A LC',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                storyBloc.getBody,
                                                textAlign: storyBloc.getAlign,
                                                style: TextStyle(
                                                  color: storyBloc.getTextColor,
                                                  fontSize: 18,
                                                  fontFamily: 'Styrene A LC',
                                                  fontWeight: storyBloc
                                                      .getCustomTextWeight,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
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
            );
          })
        : const SizedBox();
  }

  _buildImageDecoration(StoryBloc storyBloc) {
    return storyBloc.getDecorationImageUrl != null
        ? CachedNetworkImage(
            imageUrl: BASE_URL_IMAGE + storyBloc.getDecorationImageUrl,
            imageBuilder: (context, imageProvider) {
              return GestureDetector(
                onLongPress: () {
                  storyBloc.setRemoveButtonStatus(
                      storyBloc.getRemoveEnabled ? false : true);
                },
                child: MatrixGestureDetector(
                    onMatrixUpdate: (m, tm, sm, rm) {
                      storyBloc.notifierDecoration.value = m;
                    },
                    child: AnimatedBuilder(
                      animation: storyBloc.notifierDecoration,
                      builder: (ctx, child) {
                        return Transform(
                          transform: storyBloc.notifierDecoration.value,
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image(image: imageProvider),
                                  ),
                                  storyBloc.getRemoveEnabled
                                      ? Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 10,
                                                    color: Colors.grey[400],
                                                  )
                                                ]),
                                            child: GestureDetector(
                                              onTap: () {
                                                storyBloc
                                                    .setDecorationImage(null);
                                              },
                                              child: Icon(
                                                Icons.close_rounded,
                                                color: Colors.red,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    )),
              );
            },
            placeholder: (context, url) => Container(
              color: Colors.grey,
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          )
        : const SizedBox();
  }
}

class Boxer {
  final Rect bounds;
  final Rect src;
  Rect dst;

  Boxer(this.bounds, this.src);

  void clamp(Matrix4 m) {
    dst = MatrixUtils.transformRect(m, src);
    if (bounds.left <= dst.left &&
        bounds.top <= dst.top &&
        bounds.right >= dst.right &&
        bounds.bottom >= dst.bottom) {
      // bounds contains dst
      return;
    }

    if (dst.width > bounds.width || dst.height > bounds.height) {
      Rect intersected = dst.intersect(bounds);
      FittedSizes fs = applyBoxFit(BoxFit.contain, dst.size, intersected.size);

      vector.Vector3 t = vector.Vector3.zero();
      intersected = Alignment.center.inscribe(fs.destination, intersected);
      if (dst.width > bounds.width)
        t.y = intersected.top;
      else
        t.x = intersected.left;

      var scale = fs.destination.width / src.width;
      vector.Vector3 s = vector.Vector3(scale, scale, 0);
      m.setFromTranslationRotationScale(t, vector.Quaternion.identity(), s);
      return;
    }

    if (dst.left < bounds.left) {
      m.leftTranslate(bounds.left - dst.left, 0.0);
    }
    if (dst.top < bounds.top) {
      m.leftTranslate(0.0, bounds.top - dst.top);
    }
    if (dst.right > bounds.right) {
      m.leftTranslate(bounds.right - dst.right, 0.0);
    }
    if (dst.bottom > bounds.bottom) {
      m.leftTranslate(0.0, bounds.bottom - dst.bottom);
    }
  }
}
