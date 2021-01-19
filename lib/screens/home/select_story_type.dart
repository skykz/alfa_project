import 'dart:developer';
import 'dart:io';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/home/select_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SelectTypeTemplate extends StatefulWidget {
  const SelectTypeTemplate({Key key}) : super(key: key);

  @override
  _SelectTypeTemplateState createState() => _SelectTypeTemplateState();
}

class _SelectTypeTemplateState extends State<SelectTypeTemplate> {
  bool isGranted = false;

  @override
  void initState() {
    super.initState();
  }

  // _permissionFileWrite() async {
  //   var status = await Permission.storage.status;
  //   if (!status.isGranted) {
  //     await Permission.storage.request();
  //   } else {
  //     setState(() {
  //       isGranted = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppStyle.mainbgColor,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        brightness: Brightness.light, // this makes status bar text color black
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Выберите размер',
          style: TextStyle(
            fontFamily: Platform.isIOS ? 'SF Pro Display' : '',
            fontSize: 14.0.sp,
            fontWeight: FontWeight.bold,
            color: AppStyle.colorDark,
          ),
        ),
        elevation: 10,
        shadowColor: Colors.grey[300],
      ),
      body: Column(
        children: [
          const Spacer(
            flex: 2,
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<StoryBloc>(
                  builder: (context, value, child) => GestureDetector(
                    onTap: () {
                      value.setTypeOfTemplate(true);
                    },
                    child: Container(
                      height: height * 0.35,
                      width: width / 2.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: value.getIsStoryTemplate
                            ? [
                                BoxShadow(
                                  color: Colors.red[200],
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                )
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                ),
                              ],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: FittedBox(
                          child: Center(
                            child: Text(
                              'Для сторис',
                              style: TextStyle(
                                fontSize: 20.0.sp,
                                fontFamily:
                                    Platform.isIOS ? 'SF Pro Display' : '',
                                fontWeight: FontWeight.bold,
                                color: value.getIsStoryTemplate
                                    ? AppStyle.colorRed
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Consumer<StoryBloc>(
                  builder: (context, value, child) => GestureDetector(
                    onTap: () {
                      value.setTypeOfTemplate(false);
                    },
                    child: Container(
                      height: height * 0.28,
                      width: width / 2.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: !value.getIsStoryTemplate
                            ? [
                                BoxShadow(
                                  color: Colors.red[200],
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                )
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.grey[300],
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                ),
                              ],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: FittedBox(
                          child: Center(
                            child: Text(
                              'Для постов',
                              style: TextStyle(
                                fontFamily:
                                    Platform.isIOS ? 'SF Pro Display' : '',
                                fontSize: 20.0.sp,
                                fontWeight: FontWeight.bold,
                                color: value.getIsStoryTemplate
                                    ? Colors.grey
                                    : AppStyle.colorRed,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  child: FlatButton(
                    color: AppStyle.colorRed,
                    onPressed: () {
                      final va = Provider.of<StoryBloc>(context, listen: false);
                      inspect(va.getIsStoryTemplate);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectTemplateScreen(),
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
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
              ),
            ],
          )
        ],
      ),
    );
  }
}
