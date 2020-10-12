import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/screens/search/search_picker.dart';
import 'package:flutter/material.dart';

class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchPickerScreen(
                                      isText: true,
                                    ),
                                  ),
                                );
                              },
                              iconImagePath: SvgIconsClass.textSizeIcon,
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
                          horizontal: 10, vertical: 5),
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
                                    builder: (context) => SearchPickerScreen(
                                      isText: false,
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
                              fontSize: 12,
                              height: 1.1,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: BounceButton(
                          onPressed: () {},
                          iconImagePath: SvgIconsClass.saveIcon,
                        ),
                      ),
                      Text(
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
            )
          ],
        ),
      ),
    );
  }
}
