import 'dart:io';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/components/widgets/custom_card_general.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/home/filters/filter_template_picture.dart';
import 'package:alfa_project/screens/home/home_screen.dart';
import 'package:alfa_project/utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SelectTemplateScreen extends StatefulWidget {
  const SelectTemplateScreen({Key key}) : super(key: key);

  @override
  _SelectTemplateScreenState createState() => _SelectTemplateScreenState();
}

class _SelectTemplateScreenState extends State<SelectTemplateScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light, // this makes status bar text color black

        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: AppStyle.colorDark,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Выберите цвет',
          style: TextStyle(
            fontSize: 14.0.sp,
            fontFamily: Platform.isIOS ? 'SF Pro Display' : '',
            color: AppStyle.colorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 10,
        shadowColor: Colors.grey[300],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: CardGeneralWidget(
                  colorMain: AppStyle.colorRed,
                  height: height * 0.2,
                  colorText: Colors.white,
                  imageAsset: 'assets/images/png/red1.png',
                  shadowColor: index == 1 ? Colors.red[300] : null,
                  title: 'Красный\nфон',
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: CardGeneralWidget(
                  height: height * 0.2,
                  colorMain: Colors.white,
                  colorText: AppStyle.colorRed,
                  imageAsset: 'assets/images/png/red3.png',
                  shadowColor: index == 2 ? Colors.red[300] : null,
                  title: 'Серый\nфон',
                ),
              ),
              const Divider(
                height: 42,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                },
                child: CardGeneralWidget(
                  height: height * 0.2,
                  colorMain: AppStyle.colorRed,
                  imageAsset: 'assets/images/png/red2.png',
                  shadowColor: index == 3 ? Colors.red[300] : null,
                  title: 'Готовые\nРамки',
                  colorText: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (ctx) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: FlatButton(
            color: AppStyle.colorRed,
            onPressed: () => _onTapTemplate(index, ctx),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Дальше',
                    style: TextStyle(
                      fontSize: 15.0.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3, left: 5),
                    child: SvgPicture.asset(
                      'assets/images/svg/arrow_r.svg',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onTapTemplate(int val, BuildContext ctx) {
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);

    switch (val) {
      case 1:
        storyBloc.setStoryBackgroundColor(AppStyle.colorRed);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeMainScreen(
              mainColor: AppStyle.colorRed,
            ),
          ),
        );
        break;
      case 2:
        storyBloc.setStoryBackgroundColor(
          Color.fromRGBO(237, 237, 237, 1),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeMainScreen(
              mainColor: Color.fromRGBO(237, 237, 237, 1),
            ),
          ),
        );
        break;

      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilterImageScreen(
              isStory: storyBloc.getIsStoryTemplate,
            ),
          ),
        );
        break;
      default:
        showCustomSnackBar(
          ctx,
          'Выберите один из шаблонов',
          AppStyle.colorDark,
          Icons.cancel_rounded,
        );
        return null;
    }
  }
}
