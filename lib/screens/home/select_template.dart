import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/components/widgets/custom_card_general.dart';
import 'package:alfa_project/screens/home/filter_template_picture.dart';
import 'package:alfa_project/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

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
            icon: Icon(Icons.arrow_back_ios),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeMainScreen(),
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
                Divider(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeMainScreen(),
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
                  height: 30,
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
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    Expanded(
                      child: FlatButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: FlatButton(
                            color: AppStyle.colorRed,
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeMainScreen(),
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Дальше',
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
