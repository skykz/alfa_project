import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/components/widgets/custom_card_general.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/home/filters/filter_template_picture.dart';
import 'package:alfa_project/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectTemplateScreen extends StatelessWidget {
  const SelectTemplateScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: AppStyle.colorDark,
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Выберете цвет',
            style: TextStyle(
              color: AppStyle.colorDark,
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
                    final storyBloc =
                        Provider.of<StoryBloc>(context, listen: false);
                    storyBloc.setStoryBackgroundColor(AppStyle.colorRed);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeMainScreen(
                          mainColor: AppStyle.colorRed,
                        ),
                      ),
                    );
                  },
                  child: CardGeneralWidget(
                    colorMain: AppStyle.colorRed,
                    colorText: Colors.white,
                    imageAsset: 'assets/images/png/red1.png',
                    shadowColor: Colors.red[200],
                    title: 'Красный фон',
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                InkWell(
                  onTap: () {
                    final storyBloc =
                        Provider.of<StoryBloc>(context, listen: false);
                    storyBloc.setStoryBackgroundColor(Colors.grey);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeMainScreen(
                          mainColor: Colors.grey,
                        ),
                      ),
                    );
                  },
                  child: CardGeneralWidget(
                    colorMain: Colors.white,
                    colorText: AppStyle.colorRed,
                    imageAsset: 'assets/images/png/red3.png',
                    shadowColor: Colors.red[200],
                    title: 'Серый фон',
                  ),
                ),
                Divider(
                  height: 42,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilterImageScreen(),
                      ),
                    );
                  },
                  child: CardGeneralWidget(
                    colorMain: AppStyle.colorRed,
                    imageAsset: 'assets/images/png/red2.png',
                    shadowColor: Colors.red[200],
                    title: 'Готовые Рамки',
                    colorText: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
