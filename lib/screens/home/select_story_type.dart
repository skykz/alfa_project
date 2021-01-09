import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/home/select_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectTypeTemplate extends StatefulWidget {
  const SelectTypeTemplate({Key key}) : super(key: key);

  @override
  _SelectTypeTemplateState createState() => _SelectTypeTemplateState();
}

class _SelectTypeTemplateState extends State<SelectTypeTemplate> {
  bool isFirstContainerSelected = true;
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.mainbgColor,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            'Выберите размер',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
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
                  GestureDetector(
                    onTap: () {
                      if (!isFirstContainerSelected)
                        setState(() {
                          isFirstContainerSelected = true;
                        });
                    },
                    child: Container(
                      height: height * 0.35,
                      width: width / 2.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: isFirstContainerSelected
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isFirstContainerSelected
                                    ? AppStyle.colorRed
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isFirstContainerSelected)
                        setState(() {
                          isFirstContainerSelected = false;
                        });
                    },
                    child: Container(
                      height: height * 0.28,
                      width: width / 2.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: !isFirstContainerSelected
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
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isFirstContainerSelected
                                    ? Colors.grey
                                    : AppStyle.colorRed,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 40),
                    child: FlatButton(
                      color: AppStyle.colorRed,
                      onPressed: () {
                        final homeModel =
                            Provider.of<StoryBloc>(context, listen: false);
                        homeModel.setTypeOfAlfa(isFirstContainerSelected);
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
                              const Text(
                                'Дальше',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 25,
                                  color: Colors.white,
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
      ),
    );
  }
}
