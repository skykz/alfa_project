import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:alfa_project/provider/filter_bloc.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/search/search_image_text.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:sizer/sizer.dart';

import '../../../app.dart';

class CreateEditFilterTemplateScreen extends StatefulWidget {
  final String templateImageId;
  final File filteredImage;
  final bool isStory;

  CreateEditFilterTemplateScreen({
    this.templateImageId,
    this.isStory,
    this.filteredImage,
  });

  @override
  _CreateEditFilterTemplateScreenState createState() =>
      _CreateEditFilterTemplateScreenState();
}

class _CreateEditFilterTemplateScreenState
    extends State<CreateEditFilterTemplateScreen> {
  final globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storyBloc = Provider.of<StoryBloc>(context, listen: false);
      storyBloc.setSavingState(false);
    });
  }

  _goBack() {
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);
    final filterBloc = Provider.of<FilterBloc>(context, listen: false);
    storyBloc.setClearStoryData();
    filterBloc.setClearFilterData();
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      color: AppStyle.colorWhite,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => displayCustomDialog(
              context,
              "Вы точно хотите покинуть эту страницу?\n",
              DialogType.AlertDialog,
              true,
              null,
              _goBack),
          child: Scaffold(
            backgroundColor: AppStyle.colorWhite,
            resizeToAvoidBottomPadding: false,
            body: Consumer<StoryBloc>(builder: (context, storyBloc, child) {
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: [
                    Center(
                      child: Align(
                        alignment: this.widget.isStory
                            ? Alignment.bottomCenter
                            : Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ]),
                          child: AspectRatio(
                            aspectRatio:
                                this.widget.isStory ? (9 / 16) : (4 / 5),
                            child: RepaintBoundary(
                              key: globalKey,
                              child: Container(
                                color: const Color.fromRGBO(237, 237, 237, 1),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    MatrixGestureDetector(
                                      shouldRotate:
                                          !storyBloc.getImagePositionState,
                                      shouldScale:
                                          !storyBloc.getImagePositionState,
                                      shouldTranslate:
                                          !storyBloc.getImagePositionState,
                                      onMatrixUpdate: (m, tm, sm, rm) {
                                        storyBloc.notifierPicture.value = m;
                                      },
                                      child: !storyBloc.getImagePositionState
                                          ? AnimatedBuilder(
                                              animation:
                                                  storyBloc.notifierPicture,
                                              builder: (ctx, child) {
                                                return Transform(
                                                  transform: storyBloc
                                                      .notifierPicture.value,
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: <Widget>[
                                                      Image(
                                                          image: FileImage(widget
                                                              .filteredImage)),
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
                                                  transform: storyBloc
                                                      .getCurrenImagePosition,
                                                  child: Stack(
                                                    fit: StackFit.expand,
                                                    children: <Widget>[
                                                      Image(
                                                        image: FileImage(widget
                                                            .filteredImage),
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
                                        imageUrl: BASE_URL_IMAGE +
                                            widget.templateImageId,
                                        imageBuilder:
                                            (context, imageProvider) => InkWell(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onTap: () => {},
                                          child: Container(
                                            height: width,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => Center(
                                          child:
                                              const CircularProgressIndicator(
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
                          ),
                        ),
                      ),
                    ),
                    _buildToolBar(storyBloc),
                    storyBloc.getTextEnabled
                        ? const SizedBox()
                        : storyBloc.getImagePositionState
                            ? Positioned(
                                top: 10,
                                left: 15,
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
                                        iconImagePath: IconsClass.closeIconDark,
                                      ),
                                    ),
                                    Text(
                                      'Закрыть',
                                      style: TextStyle(
                                        fontSize: 8.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff172A3F),
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
                                right: 15,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: BounceButton(
                                        onPressed: () {
                                          storyBloc.setClearStoryData();
                                          Navigator.pop(context);
                                        },
                                        iconImagePath: IconsClass.closeIconDark,
                                      ),
                                    ),
                                    Text(
                                      'Закрыть',
                                      style: TextStyle(
                                        fontSize: 8.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff172A3F),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Positioned(
                                top: 10,
                                right: 15,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: BounceButton(
                                              onPressed: () {
                                                storyBloc.setTextEnabled(true);
                                              },
                                              iconImagePath:
                                                  IconsClass.textSelectIconDark,
                                            ),
                                          ),
                                          Text(
                                            'Текст',
                                            style: TextStyle(
                                              fontSize: 8.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff172A3F),
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
                                                        SearchPickerScreen(
                                                      isText: false,
                                                      isDecorationCategory:
                                                          true,
                                                      isTextToImage: false,
                                                    ),
                                                  ),
                                                );
                                              },
                                              iconImagePath:
                                                  IconsClass.stickerIconDark,
                                            ),
                                          ),
                                          Text(
                                            'Стикеры',
                                            style: TextStyle(
                                              fontSize: 8.0.sp,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff172A3F),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    Positioned(
                      bottom: 10,
                      right: 15,
                      child: !storyBloc.getTextEnabled
                          ? storyBloc.getImagePositionState
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 45,
                                      width: 45,
                                      child: BounceButton(
                                        onPressed: _capturePng,
                                        iconImagePath: IconsClass.saveIconDark,
                                      ),
                                    ),
                                    Text(
                                      'Сохранить',
                                      style: TextStyle(
                                        fontSize: 8.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff172A3F),
                                      ),
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 45,
                                      width: 45,
                                      child: BounceButton(
                                        onPressed: () {
                                          storyBloc.setImagePositionState(true);
                                        },
                                        iconImagePath: IconsClass.doneIconDark,
                                      ),
                                    ),
                                    Text(
                                      'Готово',
                                      style: TextStyle(
                                        fontSize: 8.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff172A3F),
                                      ),
                                    )
                                  ],
                                )
                          : storyBloc.getTextPositionSaved
                              ? Column(
                                  children: [
                                    SizedBox(
                                      height: 45,
                                      width: 45,
                                      child: BounceButton(
                                        onPressed: _capturePng,
                                        iconImagePath: IconsClass.saveIconDark,
                                      ),
                                    ),
                                    Text(
                                      'Сохранить',
                                      style: TextStyle(
                                        fontSize: 8.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff172A3F),
                                      ),
                                    )
                                  ],
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 45,
                                      width: 45,
                                      child: BounceButton(
                                        onPressed: () {
                                          storyBloc.setTextPosition(true);
                                          FocusScope.of(context).unfocus();
                                        },
                                        iconImagePath: IconsClass.doneIconDark,
                                      ),
                                    ),
                                    Text(
                                      'Готово',
                                      style: TextStyle(
                                        fontSize: 8.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff172A3F),
                                      ),
                                    )
                                  ],
                                ),
                    ),
                    storyBloc.getImagePositionState
                        ? Positioned(
                            bottom: 10,
                            left: 15,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: BounceButton(
                                    onPressed: () {
                                      if (storyBloc.getChildrenStickers.length >
                                          0)
                                        storyBloc.removeLastWidgetChildren();
                                      else
                                        storyBloc.setUndoImageState(false);
                                    },
                                    iconImagePath: IconsClass.undoIconDark,
                                  ),
                                ),
                                Text(
                                  'Вернуть',
                                  style: TextStyle(
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff172A3F),
                                  ),
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                    storyBloc.getTextEnabled
                        ? Positioned(
                            bottom: 10,
                            left: 15,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 45,
                                  width: 45,
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
                                    iconImagePath: IconsClass.undoIconDark,
                                  ),
                                ),
                                Text(
                                  'Вернуть',
                                  style: TextStyle(
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff172A3F),
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
                                bottom: 70,
                                left: 55,
                                right: 55,
                                child: Column(
                                  children: [
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        thumbShape: RoundSliderThumbShape(
                                          elevation: 10,
                                          enabledThumbRadius: 10,
                                          pressedElevation: 12,
                                        ),
                                      ),
                                      child: Slider(
                                        activeColor: Colors.white,
                                        inactiveColor:
                                            Colors.white.withOpacity(0.5),
                                        value: storyBloc.textWidthContainer,
                                        max: width * 0.75,
                                        min: 100,
                                        onChanged: (newValue) {
                                          storyBloc
                                              .setTextWidthContainer(newValue);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 38,
                                      child: SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                          thumbShape: RoundSliderThumbShape(
                                            elevation: 10,
                                            enabledThumbRadius: 10,
                                            pressedElevation: 12,
                                          ),
                                        ),
                                        child: Slider(
                                          value: storyBloc.textHeightContainer,
                                          activeColor: Colors.white,
                                          inactiveColor:
                                              Colors.white.withOpacity(0.5),
                                          max: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.75,
                                          min: 100,
                                          onChanged: (newValue) {
                                            storyBloc.setTextHeightContainer(
                                                newValue);
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                        : const SizedBox(),
                    StreamBuilder(
                      stream: storyBloc.getLoadingStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == false) return const SizedBox();
                        return Container(
                          color: Colors.grey.withOpacity(0.5),
                          child: const Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
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
      left: 0,
      right: 0,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              ScaleTransition(
            scale: animation,
            child: child,
          ),
          child: storyBloc.getTextPositionSaved
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: BounceButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchPickerScreen(
                                      isText: false,
                                      isDecorationCategory: true,
                                      isTextToImage: false,
                                    ),
                                  ),
                                );
                              },
                              iconImagePath: IconsClass.stickerIconDark,
                            ),
                          ),
                        ),
                        Text(
                          'Стикеры',
                          style: TextStyle(
                            fontSize: 8.0.sp,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff172A3F),
                          ),
                        ),
                      ],
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
                              iconImagePath: IconsClass.closeIconDark,
                            ),
                          ),
                          Text(
                            'Закрыть',
                            style: TextStyle(
                              fontSize: 8.0.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff172A3F),
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
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchPickerScreen(
                                            isText: true,
                                            isTextToImage: true,
                                          ),
                                        ),
                                      );
                                    },
                                    iconImagePath: IconsClass.libraryIconDark,
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    'База',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff172A3F),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
                                    onPressed: () => storyBloc.setFontSize(),
                                    iconImagePath: IconsClass.textSizeIconDark,
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    'Размер',
                                    style: TextStyle(
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff172A3F),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
                                    onPressed: () {
                                      storyBloc.setTextAlign();
                                    },
                                    iconImagePath: IconsClass.textAlignIconDark,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    'Ровнять',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff172A3F),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
                                    onPressed: () {
                                      storyBloc.setTextColor();
                                    },
                                    iconImagePath: IconsClass.fillColorIconDark,
                                  ),
                                ),
                                Text(
                                  'Цвет',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff172A3F),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
                                    onPressed: () =>
                                        storyBloc.setFontCustomWeight(),
                                    iconImagePath: IconsClass.boldIconDark,
                                  ),
                                ),
                                Text(
                                  'Толщина',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff172A3F),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
                                    onPressed: () {
                                      storyBloc.setUndoTextState(false);
                                      if (storyBloc.getImagePositionState ==
                                          false) storyBloc.setLoading(false);
                                    },
                                    iconImagePath: IconsClass.closeIconDark,
                                  ),
                                ),
                                Text(
                                  'Удалить',
                                  style: TextStyle(
                                    fontSize: 8.0.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff172A3F),
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
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
                                    onPressed: () {
                                      storyBloc.setTextAlign();
                                    },
                                    iconImagePath: IconsClass.textAlignIconDark,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    'Ровнять',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff172A3F),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: BounceButton(
                                      onPressed: () {
                                        storyBloc.setTextColor();
                                      },
                                      iconImagePath:
                                          IconsClass.fillColorIconDark,
                                    ),
                                  ),
                                  Text(
                                    'Цвет',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff172A3F),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: BounceButton(
                                    onPressed: () =>
                                        storyBloc.setTextBaseFontSize(),
                                    iconImagePath: IconsClass.textSizeIconDark,
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    'Размер',
                                    style: TextStyle(
                                      fontSize: 8.0.sp,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff172A3F),
                                    ),
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
                                      height: 40,
                                      width: 40,
                                      child: BounceButton(
                                        onPressed: () {
                                          storyBloc.setUndoTextState(false);
                                        },
                                        iconImagePath: IconsClass.closeIconDark,
                                      ),
                                    ),
                                    Text(
                                      'Удалить',
                                      style: TextStyle(
                                        fontSize: 8.0.sp,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xff172A3F),
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
    );
  }

  Future<void> _capturePng() {
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);
    storyBloc.setSavingState(true);

    return Future.delayed(const Duration(milliseconds: 30), () async {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      ui.Image image =
          await boundary.toImage(pixelRatio: this.widget.isStory ? 3 : 5);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File("$dir/" +
          'AlfaStory' +
          "${DateTime.now().millisecondsSinceEpoch}" +
          ".png");

      await file.writeAsBytes(pngBytes);

      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(file.path);
      log('IMage properties height: ${properties.height}');
      log('IMage properties width: ${properties.width}');

      File compressedFile = await FlutterNativeImage.compressImage(file.path,
          percentage: 0,
          quality: 100,
          targetWidth: this.widget.isStory ? 1080 : 1536,
          targetHeight: 1920);

      GallerySaver.saveImage(compressedFile.path).then((value) {
        displayCustomDialog(
          context,
          null,
          DialogType.InfoDialog,
          false,
          value,
          _goToInitialHome,
        );
      });

      storyBloc.setSavingState(false);
    });
  }

  _goToInitialHome() {
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);
    storyBloc.setClearStoryData();
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
            math.min(storyBloc.textWidthContainer,
                constraints.maxWidth - constraints.maxWidth * 0.2) -
            constraints.maxWidth * 0.06;

        double myMaxHeightTop = constraints.maxHeight -
            (this.widget.isStory
                ? constraints.maxHeight * 0.85
                : constraints.biggest.height * 0.85); //580

        double myMaxHeightBottom = this.widget.isStory
            ? (constraints.maxHeight -
                math.min(storyBloc.textHeightContainer,
                    constraints.maxHeight - constraints.maxHeight * 0.25) -
                constraints.maxHeight * 0.15)
            : (constraints.maxHeight -
                math.min(storyBloc.textHeightContainer,
                    constraints.maxHeight - constraints.maxHeight * 0.15) -
                constraints.maxHeight * 0.09);
        double myMaxWidthLeft =
            constraints.maxWidth - constraints.maxWidth * 0.94; //330

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
                  height: this.widget.isStory
                      ? math.min(storyBloc.textHeightContainer,
                          constraints.maxHeight * 0.7)
                      : math.min(storyBloc.textHeightContainer,
                          constraints.maxHeight * 0.73),
                  width: math.min(
                      storyBloc.textWidthContainer, constraints.maxWidth),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: storyBloc.getTextPositionSaved
                          ? Colors.transparent
                          : const Color.fromRGBO(200, 203, 208, 1),
                    ),
                  ),
                  child: storyBloc.getTitle == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                                cursorColor: AppStyle.colorDark,
                                decoration: InputDecoration(
                                  fillColor: Colors.blue,
                                  contentPadding: const EdgeInsets.all(0),
                                  border: InputBorder.none,
                                  isDense: true,
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
                                cursorColor: AppStyle.colorDark,
                                decoration: InputDecoration(
                                  fillColor: Colors.blue,
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  border: InputBorder.none,
                                  isDense: true,
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
                                fontSize: storyBloc.getTitleTextBaseFontSize,
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
                                fontSize: storyBloc.getBodyTextBaseFontSize,
                                height: 1,
                                fontFamily: 'Styrene A LC',
                                fontWeight: FontWeight.normal,
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
