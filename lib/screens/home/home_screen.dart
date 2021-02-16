import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/components/widgets/fade_transition.dart';
import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/search/search_image_text.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'package:sizer/sizer.dart';

import 'package:provider/provider.dart';

import '../../app.dart';
import 'create_text_story.dart';

class HomeMainScreen extends StatefulWidget {
  final Color mainColor;
  HomeMainScreen({Key key, this.mainColor}) : super(key: key);

  @override
  _HomeMainScreenState createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storyBloc = Provider.of<StoryBloc>(context, listen: false);
      storyBloc.setSavingState(false);
    });
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
          child: Scaffold(
            body: Container(
              color: widget.mainColor,
              child: Stack(
                fit: StackFit.expand,
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
                          aspectRatio:
                              storyBloc.getIsStoryTemplate ? (9 / 16) : (4 / 5),
                          child: RepaintBoundary(
                            key: globalKey,
                            child: Scaffold(
                              backgroundColor: widget.mainColor,
                              body: Stack(
                                children: [
                                  Image.asset(
                                    setBackgroundImage(
                                        storyBloc.getIsStoryTemplate,
                                        widget.mainColor),
                                  ),
                                  Positioned(
                                    left: 25,
                                    bottom: 20,
                                    right: 50,
                                    child: Text(
                                      '№ 1.2.61/237 лицензия. 03.02.2020ж. РҚНРДА берген.\nЛицензия № 1.2.61/237. Выдана АРРФР от 03.02.2020.',
                                      style: TextStyle(
                                        fontSize: 6.0.sp,
                                        color: widget.mainColor ==
                                                AppStyle.colorRed
                                            ? Colors.white
                                            : AppStyle.colorDark,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: AppStyle.colorDark,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Row(
                            children: [
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
                                          Navigator.pushReplacement(
                                            context,
                                            FadeRouteBuilder(
                                              page: CreateTextTemplateScreen(),
                                            ),
                                          );
                                        },
                                        iconImagePath: storyBloc.getBackColor ==
                                                AppStyle.colorRed
                                            ? IconsClass.textSelectIcon
                                            : IconsClass.textSelectIconDark,
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
                                              isText: false,
                                              isTextToImage: true,
                                            ),
                                          ),
                                        );
                                      },
                                      iconImagePath: storyBloc.getBackColor ==
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
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 45,
                                width: 45,
                                child: BounceButton(
                                  onPressed: _capturePng,
                                  iconImagePath: storyBloc.getBackColor ==
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
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
    );
  }

  Future<void> _capturePng() {
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);
    storyBloc.setSavingState(true);
    return Future.delayed(const Duration(milliseconds: 5005), () async {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();

      ui.Image image = await boundary.toImage(pixelRatio: 3);

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
}
