import 'dart:io';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:alfa_project/provider/filter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterImageScreen extends StatefulWidget {
  const FilterImageScreen({Key key}) : super(key: key);

  @override
  _FilterImageScreenState createState() => _FilterImageScreenState();
}

class _FilterImageScreenState extends State<FilterImageScreen> {
  PageController controller;
  int currentpage = 0;

  @override
  initState() {
    super.initState();

    controller = PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 0.85,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

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
            'Выберете рамку',
            style: TextStyle(
              color: AppStyle.colorDark,
            ),
          ),
          elevation: 10,
          shadowColor: Colors.grey[300],
          centerTitle: true,
        ),
        body: Consumer<FilterBloc>(
          builder: (context, bloc, child) {
            return Column(
              children: [
                bloc.getLoading
                    ? Expanded(
                        child: Center(
                          child: SizedBox(
                            height: 35,
                            width: 35,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Container(
                              child: PageView.builder(
                                onPageChanged: (value) {
                                  setState(() {
                                    currentpage = value;
                                  });
                                },
                                itemCount: bloc.getListTemplates['data'].length,
                                controller: controller,
                                itemBuilder: (context, index) =>
                                    templateBuilder(
                                        index, bloc.getListTemplates),
                              ),
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Builder(
                    builder: (ctx) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 30),
                      child: FlatButton(
                        color: AppStyle.colorRed,
                        onPressed: () =>
                            _showSelectFile(bloc, Platform.isAndroid, context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: SizedBox(
                            height: 25,
                            width: double.infinity,
                            child: Center(
                              child: Consumer<FilterBloc>(
                                  builder: (context, bloc, child) {
                                return bloc.getImageLoading
                                    ? CircularProgressIndicator()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Выбрать',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(
                                            Icons.arrow_forward,
                                            size: 25,
                                            color: Colors.white,
                                          ),
                                        ],
                                      );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  templateBuilder(int index, filterImageData) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .7)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * 500,
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: CachedNetworkImage(
          imageUrl: BASE_URL_IMAGE + filterImageData['data'][index]['url'],
          imageBuilder: (context, imageProvider) => InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => {},
            child: Container(
              width: 500,
              decoration: BoxDecoration(
                border: index == currentpage
                    ? Border.all(
                        color: AppStyle.colorDark,
                        width: 5,
                      )
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          placeholder: (context, url) => Center(
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.white,
            ),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  _showSelectFile(val, bool isAndroid, BuildContext context) {
    final filterBloc = Provider.of<FilterBloc>(context, listen: false);

    if (isAndroid)
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: Icon(Icons.camera, color: AppStyle.colorRed),
                title: Text('Камера'),
                onTap: () => filterBloc.getImage(context,
                    filterBloc.getListTemplates['data'][currentpage]['url']),
              ),
              ListTile(
                leading: Icon(Icons.image_outlined, color: AppStyle.colorRed),
                title: Text('Галлерея'),
                onTap: () {
                  filterBloc.pickFileFrom(context,
                      filterBloc.getListTemplates['data'][currentpage]['url']);
                },
              ),
            ],
          ),
        ),
      );
    else
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: Text(
            'Выберите путь',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'Галлерея',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                filterBloc.pickFileFrom(context,
                    filterBloc.getListTemplates['data'][currentpage]['url']);
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'iCloud Драйф',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                print('pressed');
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'Камера',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onPressed: () => filterBloc.getImage(context,
                  filterBloc.getListTemplates['data'][currentpage]['url']),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Отменить'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
  }
}
