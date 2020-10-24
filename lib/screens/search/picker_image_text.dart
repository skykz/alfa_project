import 'dart:io';

import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:alfa_project/provider/search_text_image.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/home/create_edit_template.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:provider/provider.dart';

class StickerTextPicker extends StatelessWidget {
  final int id;
  final bool isTextBase;
  final bool isDecoration;

  final String text;
  final String title;
  const StickerTextPicker({
    Key key,
    this.id,
    this.isDecoration = false,
    this.title,
    this.isTextBase,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchTextImageBloc>(context, listen: false);
    final storyBloc = Provider.of<StoryBloc>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF6E7886).withOpacity(0.8),
        resizeToAvoidBottomPadding: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 3),
                  child: FlatButton(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: Colors.white,
                        ),
                        const Text(
                          'Назад',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Flexible(
                  child: Text(
                    isDecoration ? 'Декорация' : '$title',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    height: 35,
                    width: 35,
                    child: BounceButton(
                      onPressed: () {
                        bloc.setClearData();
                        Navigator.pop(context);
                      },
                      iconImagePath: SvgIconsClass.closeIcon,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            !isDecoration
                ? isTextBase
                    ? ListTile(
                        onTap: () {
                          storyBloc.setTitleBodyString(title, text);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        title: Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      )
                    : FutureBuilder(
                        future: bloc.getImages(id, context),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null)
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Center(
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          if (snapshot.data['data'].length == 0)
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'пусто',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data['data'].length,
                            padding: const EdgeInsets.all(8),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(5),
                              child: CachedNetworkImage(
                                imageUrl: BASE_URL_IMAGE +
                                    snapshot.data['data'][index]['icon'],
                                imageBuilder: (context, imageProvider) =>
                                    InkWell(
                                  borderRadius: BorderRadius.circular(5),
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateEditTemplateScreen(
                                        imageUrl: snapshot.data['data'][index]
                                            ['url'],
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => Center(
                                  child: !Platform.isAndroid
                                      ? const CupertinoActivityIndicator(
                                          radius: 15,
                                        )
                                      : SizedBox(
                                          height: 25,
                                          width: 25,
                                          child:
                                              const CircularProgressIndicator(
                                            strokeWidth: 2,
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          );
                        },
                      )
                : FutureBuilder(
                    future: bloc.getImages(118, context),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data == null)
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Platform.isAndroid
                                ? const Center(
                                    child: SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  )
                                : const Center(
                                    child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CupertinoActivityIndicator(
                                          radius: 15,
                                        )),
                                  ),
                          ],
                        );
                      if (snapshot.data['data'].length == 0)
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'пусто',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        );
                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data['data'].length,
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(5),
                          child: CachedNetworkImage(
                            imageUrl: BASE_URL_IMAGE +
                                snapshot.data['data'][index]['icon'],
                            imageBuilder: (context, imageProvider) => InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () {
                                storyBloc.setDecorationImage(
                                    snapshot.data['data'][index]['url']);
                                Navigator.pop(context);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Center(
                              child: !Platform.isAndroid
                                  ? const CupertinoActivityIndicator(
                                      radius: 15,
                                    )
                                  : SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
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
}
