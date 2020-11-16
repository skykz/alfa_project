import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/search/picker_image_text.dart';
import 'package:alfa_project/screens/search/search_image_text.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import '../../../app.dart';

class CreateEditFilterTemplateScreen extends StatefulWidget {
  final String templateImageId;
  final File filteredImage;

  CreateEditFilterTemplateScreen({
    this.templateImageId,
    this.filteredImage,
  });

  @override
  _CreateEditFilterTemplateScreenState createState() =>
      _CreateEditFilterTemplateScreenState();
}

class _CreateEditFilterTemplateScreenState
    extends State<CreateEditFilterTemplateScreen> {
  _goBack() {
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);
    storyBloc.setClearStoryData();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  GlobalKey globalKey = GlobalKey();

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
                    color: Color.fromRGBO(237, 237, 237, 1),
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
                                          Image(
                                              image: FileImage(
                                                  widget.filteredImage)),
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
                                          Image(
                                            image:
                                                FileImage(widget.filteredImage),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: CachedNetworkImage(
                            imageUrl: BASE_URL_IMAGE + widget.templateImageId,
                            imageBuilder: (context, imageProvider) => InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => {},
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Center(
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: Colors.white,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        storyBloc.getTextEnabled
                            ? _buildTextWidget(storyBloc)
                            : const SizedBox(),
                        _buildDecoImage(),
                      ],
                    ),
                  ),
                ),
                _buildToolBar(storyBloc),
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
                        : SizedBox(),
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
                                          fontSize: 11,
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
                                          fontSize: 11,
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
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
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
                            )
                      : storyBloc.getTextPositionSaved
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
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
                                onPressed: () {
                                  if (storyBloc.getChildrenStickers.length > 0)
                                    storyBloc.removeLastWidgetChildren();
                                  else
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
                                  if (storyBloc.getChildrenStickers.length >
                                      0) {
                                    storyBloc.removeLastWidgetChildren();
                                  } else {
                                    storyBloc.setUndoTextState(false);
                                    if (storyBloc.getImagePositionState ==
                                        false) storyBloc.setLoading(false);
                                  }
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
                                    thumbShape: RoundSliderThumbShape()),
                                child: Slider(
                                  value: storyBloc.textWidthContainer,
                                  max: MediaQuery.of(context).size.width * 0.75,
                                  min: 5,
                                  onChanged: (newValue) {
                                    storyBloc.setTextWidthContainer(newValue);
                                    log('$newValue');
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

  _buildDecoImage() {
    final storyBloc = Provider.of<StoryBloc>(context);

    return Stack(
      children: storyBloc.getChildrenStickers,
    );
  }

  Widget _buildToolBar(StoryBloc storyBloc) {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) =>
            ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: storyBloc.getTextPositionSaved
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
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
                                  builder: (context) => StickerTextPicker(
                                    isDecoration: true,
                                    isTextBase: false,
                                    title: "",
                                    text: "",
                                  ),
                                ),
                              );
                            },
                            iconImagePath: SvgIconsClass.stickerIcon,
                          ),
                        ),
                        Text(
                          'Стикеры',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: BounceButton(
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
                            fontWeight: FontWeight.w300,
                            color: AppStyle.colorDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : storyBloc.getTextEnabled
                ? storyBloc.getTitle == null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        builder: (context) => StickerTextPicker(
                                          isDecoration: true,
                                          isTextBase: false,
                                          title: "",
                                          text: "",
                                        ),
                                      ),
                                    );
                                  },
                                  iconImagePath: SvgIconsClass.libraryIcon,
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
                                  onPressed: () => storyBloc.setFontSize(),
                                  iconImagePath: SvgIconsClass.textSelectIcon,
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
                                  iconImagePath: SvgIconsClass.textAlignIcon,
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
                                  iconImagePath: SvgIconsClass.fillColorIcon,
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
                                  onPressed: () =>
                                      storyBloc.setFontCustomWeight(),
                                  iconImagePath: SvgIconsClass.boldIcon,
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
                                  fontWeight: FontWeight.w300,
                                  color: AppStyle.colorDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                                  iconImagePath: SvgIconsClass.textAlignIcon,
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
                                  iconImagePath: SvgIconsClass.fillColorIcon,
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
                                      fontWeight: FontWeight.w300,
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

  _buildTextWidget(StoryBloc storyBloc) {
    return IgnorePointer(
      ignoring: storyBloc.getTextPositionSaved,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double myMaxWidthRight = constraints.maxWidth -
            math.min(storyBloc.textWidthContainer, constraints.maxWidth - 30) -
            30;

        double myMaxHeightTop = constraints.maxHeight - 580;
        double myMaxHeightBottom = constraints.maxHeight - 250;
        double myMaxWidthLeft = constraints.maxWidth - 330;

        return Stack(
          children: [
            Positioned(
              left: storyBloc.getOffset.dx,
              top: storyBloc.getOffset.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  Offset offset = Offset(
                      storyBloc.getOffset.dx + details.delta.dx,
                      storyBloc.getOffset.dy + details.delta.dy);

                  storyBloc.setOffsetText(
                    Offset(
                      math.max(
                          math.min(myMaxWidthRight, offset.dx), myMaxWidthLeft),
                      math.max(math.min(myMaxHeightBottom, offset.dy),
                          myMaxHeightTop),
                    ),
                  );
                },
                child: Container(
                  width: math.min(
                      storyBloc.textWidthContainer, constraints.maxWidth - 80),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: storyBloc.getTextPositionSaved
                          ? Colors.transparent
                          : Color.fromRGBO(200, 203, 208, 1),
                    ),
                  ),
                  child: storyBloc.getTitle == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: storyBloc.getTextAlignment,
                          children: [
                              TextField(
                                cursorRadius: Radius.circular(2),
                                textAlign: storyBloc.getAlign,
                                style: TextStyle(
                                  color: storyBloc.getTextColorFirst,
                                  fontSize: storyBloc.getTitleFontSize,
                                  fontFamily: 'Styrene A LC',
                                  fontWeight:
                                      storyBloc.getCustomTextWeightFirst,
                                ),
                                onTap: () {
                                  storyBloc.setTextFieldEnable(true);
                                },
                                maxLines: null,
                                cursorColor: AppStyle.colorRed,
                                decoration: InputDecoration(
                                  fillColor: Colors.blue,
                                  border: InputBorder.none,
                                  hintText: storyBloc.getTextPositionSaved
                                      ? ''
                                      : 'Напишите что-нибудь...',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  helperStyle: TextStyle(
                                    fontSize: 15,
                                    color:
                                        storyBloc.getTextColor.withOpacity(0.3),
                                  ),
                                ),
                              ),
                              TextField(
                                cursorRadius: Radius.circular(2),
                                textAlign: storyBloc.getAlign,
                                onTap: () {
                                  storyBloc.setTextFieldEnable(false);
                                },
                                style: TextStyle(
                                  color: storyBloc.getTextColorSecond,
                                  fontSize: storyBloc.getBodyFontSize,
                                  fontFamily: 'Styrene A LC',
                                  fontWeight:
                                      storyBloc.getCustomTextWeightSecond,
                                ),
                                maxLines: null,
                                cursorColor: AppStyle.colorRed,
                                decoration: InputDecoration(
                                  fillColor: Colors.blue,
                                  border: InputBorder.none,
                                  hintText: storyBloc.getTextPositionSaved
                                      ? ''
                                      : 'Напишите что-нибудь...',
                                  hintStyle: TextStyle(color: Colors.grey[400]),
                                  helperStyle: TextStyle(
                                    fontSize: 15,
                                    color:
                                        storyBloc.getTextColor.withOpacity(0.3),
                                  ),
                                ),
                              ),
                            ])
                      : Column(
                          crossAxisAlignment: storyBloc.getTextAlignment,
                          children: [
                            Text(
                              storyBloc.getTitle,
                              textAlign: storyBloc.getAlign,
                              style: TextStyle(
                                color: storyBloc.getTextColor,
                                fontSize: 24,
                                height: 0.95,
                                fontFamily: 'Styrene A LC',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Text(
                              storyBloc.getBody,
                              textAlign: storyBloc.getAlign,
                              style: TextStyle(
                                color: storyBloc.getTextColor,
                                fontSize: 16,
                                height: 1,

                                fontFamily: 'Styrene A LC',
                                fontWeight: FontWeight.normal,

                                // fontWeight: storyBloc.getCustomTextWeightFirst,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
