import 'dart:io';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:alfa_project/provider/filter_bloc.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FilterImageScreen extends StatefulWidget {
  final bool isStory;
  const FilterImageScreen({Key key, this.isStory}) : super(key: key);

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storyBloc = Provider.of<StoryBloc>(context, listen: false);

      final filterBloc = Provider.of<FilterBloc>(context, listen: false);
      filterBloc.getTemplates(context, storyBloc.getIsStoryTemplate);
    });
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<FilterBloc>(context, listen: true);

    return WillPopScope(
      onWillPop: () async => bloc.setClearForListTemplates(),
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: AppStyle.colorDark,
          ),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Navigator.pop(context);
                bloc.setClearForListTemplates();
              }),
          title: Text(
            'Выберите рамку',
            style: TextStyle(
              fontFamily: Platform.isIOS ? 'SF Pro Display' : '',
              fontWeight: FontWeight.bold,
              color: AppStyle.colorDark,
              fontSize: 14.0.sp,
            ),
          ),
          elevation: 10,
          shadowColor: Colors.grey[300],
          centerTitle: true,
        ),
        body: Column(
          children: [
            bloc.getLoading
                ? const Expanded(
                    child: Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
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
                            itemCount: bloc.getListTemplates == null
                                ? 0
                                : bloc.getListTemplates.length,
                            controller: controller,
                            itemBuilder: (context, index) =>
                                templateBuilder(index, bloc.getListTemplates),
                          ),
                        ),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Builder(
                builder: (ctx) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
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
                        width: double.infinity,
                        child: Center(
                          child: Consumer<FilterBloc>(
                              builder: (context, bloc, child) {
                            return Row(
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
                                      const EdgeInsets.only(top: 3, left: 5),
                                  child: SvgPicture.asset(
                                    'assets/images/svg/arrow_r.svg',
                                  ),
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
        ),
      ),
    );
  }

  templateBuilder(int index, filterImageData) {
    final width = MediaQuery.of(context).size.width;

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
          imageUrl: BASE_URL_IMAGE + filterImageData[index]['icon'],
          imageBuilder: (context, imageProvider) => InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => {},
            child: Container(
              width: width * 0.85,
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          placeholder: (context, url) => const SizedBox(
            width: 30,
            height: 30,
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.error_outline_rounded),
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
          child: Consumer<FilterBloc>(
            builder: (context, val, child) => val.getImageLoading
                ? SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: const SizedBox(
                        width: 30,
                        height: 30,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ListTile(
                          leading: Icon(Icons.camera_alt_rounded,
                              color: AppStyle.colorRed),
                          title: const Text('Камера'),
                          onTap: () {
                            filterBloc.setImageLoading(true);
                            filterBloc.getCamerImage(
                                context,
                                this.widget.isStory,
                                filterBloc.getListTemplates[currentpage]
                                    ['url']);
                          }),
                      ListTile(
                        leading:
                            Icon(Icons.image_rounded, color: AppStyle.colorRed),
                        title: const Text('Галлерея'),
                        onTap: () {
                          filterBloc.setImageLoading(true);
                          filterBloc.pickFileFromGallery(
                              context,
                              this.widget.isStory,
                              filterBloc.getListTemplates[currentpage]['url']);
                        },
                      ),
                    ],
                  ),
          ),
        ),
      );
    else
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          title: const Text(
            'Выберите вариант',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'SF Pro Display Regular',
            ),
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text(
                'Галлерея',
                style: TextStyle(
                  fontFamily: 'SF Pro Display Regular',
                  color: Colors.blue,
                ),
              ),
              onPressed: () {
                filterBloc.pickFileFromGallery(context, this.widget.isStory,
                    filterBloc.getListTemplates[currentpage]['url']);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(
                'Камера',
                style: TextStyle(
                  fontFamily: 'SF Pro Display Regular',
                  color: Colors.blue,
                ),
              ),
              onPressed: () => filterBloc.getCamerImage(
                  context,
                  this.widget.isStory,
                  filterBloc.getListTemplates[currentpage]['url']),
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(
              'Отменить',
              style: TextStyle(
                fontFamily: 'SF Pro Display Regular',
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
  }
}
