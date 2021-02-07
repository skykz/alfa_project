import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/components/widgets/fade_transition.dart';
import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/search/picker_image_text.dart';
import 'package:alfa_project/screens/search/search_image_text.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

import '../../app.dart';
import 'dart:math' as math;
import 'package:sizer/sizer.dart';

import 'home_screen.dart';

class CreateTextTemplateScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String text;
  CreateTextTemplateScreen({
    this.imageUrl,
    this.title,
    this.text,
  });

  @override
  _CreateEditTemplateScreenState createState() =>
      _CreateEditTemplateScreenState();
}

class _CreateEditTemplateScreenState extends State<CreateTextTemplateScreen> {
  GlobalKey globalKey = GlobalKey();
  double _valueWidth;
  double _valueHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storyBloc = Provider.of<StoryBloc>(context, listen: false);
      storyBloc.setTextEnabled(true);
      storyBloc.setSavingState(false);
      _valueWidth = MediaQuery.of(context).size.width;
      _valueHeight = MediaQuery.of(context).size.height;
    });
  }

  _goBack() {
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

  @override
  Widget build(BuildContext context) {
    final storyBloc = Provider.of<StoryBloc>(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: storyBloc.getBackColor == AppStyle.colorRed
          ? Platform.isAndroid
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Container(
        color: storyBloc.getBackColor,
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
              backgroundColor: storyBloc.getBackColor,
              resizeToAvoidBottomPadding: false,
              body: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: [
                    Center(
                      child: Align(
                        alignment: storyBloc.getIsStoryTemplate
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
                            aspectRatio: storyBloc.getIsStoryTemplate
                                ? (9 / 16)
                                : (4 / 5),
                            child: RepaintBoundary(
                              key: globalKey,
                              child: Container(
                                color: storyBloc.getBackColor,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      setBackgroundImage(
                                          storyBloc.getIsStoryTemplate,
                                          storyBloc.getBackColor),
                                    ),
                                    _buildTextWidget(),
                                    storyBloc.getImageUrl != null
                                        ? _buildMainImage()
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
                                        onPressed: () => displayCustomDialog(
                                            context,
                                            "Вы точно хотите покинуть эту страницу?\n",
                                            DialogType.AlertDialog,
                                            true,
                                            null,
                                            _goBack),
                                        iconImagePath: storyBloc.getBackColor ==
                                                AppStyle.colorRed
                                            ? IconsClass.closeIcon
                                            : IconsClass.closeIconDark,
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
                                          horizontal: 5),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: BounceButton(
                                              onPressed: () {
                                                storyBloc.setTextEnabled(true);
                                              },
                                              iconImagePath: storyBloc
                                                          .getBackColor ==
                                                      AppStyle.colorRed
                                                  ? IconsClass.textSizeIcon
                                                  : IconsClass.textSizeIconDark,
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
                                                        StickerTextPicker(
                                                      isDecoration: true,
                                                      isTextBase: false,
                                                      title: "",
                                                      text: "",
                                                    ),
                                                  ),
                                                );
                                              },
                                              iconImagePath: storyBloc
                                                          .getBackColor ==
                                                      AppStyle.colorRed
                                                  ? IconsClass.stickerIcon
                                                  : IconsClass.stickerIconDark,
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
                      child: storyBloc.getTextEnabled
                          ? storyBloc.getImageUrl == null
                              ? storyBloc.getTextPositionSaved
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 45,
                                          width: 45,
                                          child: BounceButton(
                                            onPressed: _capturePng,
                                            iconImagePath:
                                                storyBloc.getBackColor ==
                                                        AppStyle.colorRed
                                                    ? IconsClass.saveIcon
                                                    : IconsClass.saveIconDark,
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
                                            iconImagePath:
                                                storyBloc.getBackColor ==
                                                        AppStyle.colorRed
                                                    ? IconsClass.doneIcon
                                                    : IconsClass.doneIconDark,
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
                              : storyBloc.getImagePositionState
                                  ? Column(
                                      children: [
                                        SizedBox(
                                          height: 45,
                                          width: 45,
                                          child: BounceButton(
                                            onPressed: _capturePng,
                                            iconImagePath:
                                                storyBloc.getBackColor ==
                                                        AppStyle.colorRed
                                                    ? IconsClass.saveIcon
                                                    : IconsClass.saveIconDark,
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
                                              storyBloc
                                                  .setImagePositionState(true);
                                            },
                                            iconImagePath:
                                                storyBloc.getBackColor ==
                                                        AppStyle.colorRed
                                                    ? IconsClass.doneIcon
                                                    : IconsClass.doneIconDark,
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
                          : const SizedBox(),
                    ),
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
                                        if (storyBloc.getImagePositionState) {
                                          storyBloc.setUndoImageState(false);
                                          storyBloc.setImageSticker(null);
                                        } else {
                                          storyBloc.setUndoTextState(false);
                                          storyBloc.setTextEnabled(true);
                                          if (storyBloc.getImagePositionState ==
                                              false)
                                            storyBloc.setLoading(false);
                                        }
                                      }
                                    },
                                    iconImagePath: storyBloc.getBackColor ==
                                            AppStyle.colorRed
                                        ? IconsClass.undoIcon
                                        : IconsClass.undoIconDark,
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
                                        value: storyBloc.textWidthContainer,
                                        activeColor: Colors.white,
                                        inactiveColor:
                                            Colors.white.withOpacity(0.5),
                                        max: _valueWidth * 0.75,
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
                                          max: _valueHeight * 0.75,
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
                          color: Colors.grey.withOpacity(0.3),
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: Platform.isAndroid
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                    )
                                  : const CupertinoActivityIndicator(
                                      radius: 15,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
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
      left: 0,
      right: 0,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 15),
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
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 40,
                            child: BounceButton(
                              onPressed: () {
                                if (storyBloc.getImagePositionState == false)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchPickerScreen(
                                        isText: false,
                                        isTextToImage: false,
                                      ),
                                    ),
                                  );
                                else
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
                              iconImagePath:
                                  storyBloc.getBackColor == AppStyle.colorRed
                                      ? IconsClass.stickerIcon
                                      : IconsClass.stickerIconDark,
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
                    Column(
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
                            iconImagePath:
                                storyBloc.getBackColor == AppStyle.colorRed
                                    ? IconsClass.closeIcon
                                    : IconsClass.closeIconDark,
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
                  ],
                )
              : storyBloc.getTitle == null
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
                                      ));
                                },
                                iconImagePath:
                                    storyBloc.getBackColor == AppStyle.colorRed
                                        ? IconsClass.libraryIcon
                                        : IconsClass.libraryIconDark,
                              ),
                            ),
                            Text(
                              'База',
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
                                onPressed: () => storyBloc.setFontSize(),
                                iconImagePath:
                                    storyBloc.getBackColor == AppStyle.colorRed
                                        ? IconsClass.textSizeIcon
                                        : IconsClass.textSizeIconDark,
                              ),
                            ),
                            Text(
                              'Размер',
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
                                  storyBloc.setTextAlign();
                                },
                                iconImagePath:
                                    storyBloc.getBackColor == AppStyle.colorRed
                                        ? IconsClass.textAlignIcon
                                        : IconsClass.textAlignIconDark,
                              ),
                            ),
                            Text(
                              'Ровнять',
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
                                  storyBloc.setTextColor();
                                },
                                iconImagePath:
                                    storyBloc.getBackColor == AppStyle.colorRed
                                        ? IconsClass.fillColorIcon
                                        : IconsClass.fillColorIconDark,
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
                                iconImagePath:
                                    storyBloc.getBackColor == AppStyle.colorRed
                                        ? IconsClass.boldIcon
                                        : IconsClass.boldIconDark,
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
                                  Navigator.pushReplacement(
                                    context,
                                    FadeRouteBuilder(
                                      page: HomeMainScreen(
                                        mainColor: storyBloc.getBackColor,
                                      ),
                                    ),
                                  );
                                },
                                iconImagePath:
                                    storyBloc.getBackColor == AppStyle.colorRed
                                        ? IconsClass.closeIcon
                                        : IconsClass.closeIconDark,
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
                                iconImagePath:
                                    storyBloc.getBackColor == AppStyle.colorRed
                                        ? IconsClass.textAlignIcon
                                        : IconsClass.textAlignIconDark,
                              ),
                            ),
                            Text(
                              'Ровнять',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 8.0.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172A3F),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40,
                                width: 40,
                                child: BounceButton(
                                  onPressed: () {
                                    storyBloc.setTextColor();
                                  },
                                  iconImagePath: storyBloc.getBackColor ==
                                          AppStyle.colorRed
                                      ? IconsClass.fillColorIcon
                                      : IconsClass.fillColorIconDark,
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
                                iconImagePath:
                                    storyBloc.getBackColor == AppStyle.colorRed
                                        ? IconsClass.textSizeIcon
                                        : IconsClass.textSizeIconDark,
                              ),
                            ),
                            Text(
                              'Размер',
                              style: TextStyle(
                                fontSize: 8.0.sp,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff172A3F),
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
                                      storyBloc.setUndoTextBase(false);
                                    },
                                    iconImagePath: storyBloc.getBackColor ==
                                            AppStyle.colorRed
                                        ? IconsClass.closeIcon
                                        : IconsClass.closeIconDark,
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
                    ),
        ),
      ),
    );
  }

  Future<void> _capturePng() {
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);
    storyBloc.setSavingState(true);
    return Future.delayed(const Duration(milliseconds: 25), () async {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();

      ui.Image image = await boundary.toImage(
          pixelRatio: storyBloc.getIsStoryTemplate ? 4 : 5);

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
          targetWidth: storyBloc.getIsStoryTemplate ? 1080 : 1536,
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

  _buildMainImage() {
    final storyBloc = Provider.of<StoryBloc>(context);

    return CachedNetworkImage(
      imageUrl: BASE_URL_IMAGE + storyBloc.getImageUrl ?? widget.imageUrl,
      imageBuilder: (context, imageProvider) => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: MatrixGestureDetector(
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
          const Text('Проблема с интернетом!\nПроверьте интернет')
        ],
      ),
    );
  }

  _buildTextWidget() {
    return Consumer<StoryBloc>(builder: (context, storyBloc, child) {
      return IgnorePointer(
        ignoring: storyBloc.getTextPositionSaved,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double myMaxWidthRight = constraints.maxWidth -
              math.min(storyBloc.textWidthContainer,
                  constraints.maxWidth - constraints.maxWidth * 0.2) -
              constraints.maxWidth * 0.06;

          double myMaxHeightTop = constraints.maxHeight -
              (storyBloc.getIsStoryTemplate
                  ? constraints.maxHeight * 0.85
                  : constraints.biggest.height * 0.85); //580

          double myMaxHeightBottom = storyBloc.getIsStoryTemplate
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
                        math.max(math.min(myMaxWidthRight, offset.dx),
                            myMaxWidthLeft),
                        math.max(math.min(myMaxHeightBottom, offset.dy),
                            myMaxHeightTop),
                      ),
                    );
                  },
                  child: Container(
                    height: storyBloc.getIsStoryTemplate
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
                            : Color.fromRGBO(200, 203, 208, 1),
                      ),
                    ),
                    child: storyBloc.getTitle == null
                        ? Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: storyBloc.getTextAlignment,
                                children: [
                                  TextField(
                                    cursorRadius: Radius.circular(2),
                                    textAlign: storyBloc.getAlign,
                                    style: TextStyle(
                                      height: 1,
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
                                    cursorColor: storyBloc.getTextColorFirst,
                                    decoration: InputDecoration(
                                      isDense: true, // and add this line
                                      contentPadding: const EdgeInsets.all(0),
                                      fillColor: Colors.blue,
                                      border: InputBorder.none,
                                      hintText: storyBloc.getTextPositionSaved
                                          ? ''
                                          : 'Напишите что-нибудь...',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      helperStyle: TextStyle(
                                        fontSize: 15,
                                        color: storyBloc.getTextColor
                                            .withOpacity(0.3),
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
                                      height: 1.2,
                                      fontSize: storyBloc.getBodyFontSize,
                                      fontFamily: 'Styrene A LC',
                                      fontWeight:
                                          storyBloc.getCustomTextWeightSecond,
                                    ),
                                    maxLines: null,
                                    cursorColor: storyBloc.getTextColorSecond,
                                    decoration: InputDecoration(
                                      fillColor: Colors.blue,
                                      isDense: true, // and add this line
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      border: InputBorder.none,
                                      hintText: storyBloc.getTextPositionSaved
                                          ? ''
                                          : 'Напишите что-нибудь...',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                      helperStyle: TextStyle(
                                        fontSize: 15,
                                        color: storyBloc.getTextColor
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                ]),
                          )
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
                                  height: 1.2,
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
    });
  }
}
