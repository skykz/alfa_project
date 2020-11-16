import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/components/widgets/fade_transition.dart';
import 'package:alfa_project/core/data/models/dialog_type.dart';
import 'package:alfa_project/provider/home_bloc.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/search/search_image_text.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            RepaintBoundary(
              key: globalKey,
              child: Scaffold(
                backgroundColor: widget.mainColor,
              ),
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
                                iconImagePath: SvgIconsClass.textSizeIcon,
                              ),
                            ),
                            const Text(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 40,
                              width: 40,
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
                                iconImagePath: SvgIconsClass.stickerIcon,
                              ),
                            ),
                            const Text(
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
                            iconImagePath: SvgIconsClass.saveIcon,
                          ),
                        ),
                        const Text(
                          'Сохранить',
                          style: TextStyle(
                            height: 1.5,
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
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
