import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/components/widgets/fade_transition.dart';
import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/search/search_image_text.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;

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
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: storyBloc.getIsStoryTemplate
                          ? 0
                          : constraints.maxHeight * 0.15),
                  child: RepaintBoundary(
                    key: globalKey,
                    child: Scaffold(
                      backgroundColor: widget.mainColor,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 35,
                              width: 35,
                              child: BounceButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    FadeRouteBuilder(
                                      page: CreateTextTemplateScreen(),
                                    ),
                                  );
                                },
                                iconImagePath: IconsClass.textSelectIcon,
                              ),
                            ),
                            const Text(
                              'Текст',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 35,
                              width: 35,
                              child: BounceButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchPickerScreen(
                                        isText: false,
                                        isTextToImage: true,
                                      ),
                                    ),
                                  );
                                },
                                iconImagePath: IconsClass.stickerIcon,
                              ),
                            ),
                            const Text(
                              'Стикеры',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
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
                          height: 40,
                          width: 40,
                          child: BounceButton(
                            onPressed: _capturePng,
                            iconImagePath: IconsClass.saveIcon,
                          ),
                        ),
                        const Text(
                          'Сохранить',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w300,
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
