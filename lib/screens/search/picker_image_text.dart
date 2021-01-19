import 'dart:developer';
import 'dart:io';

import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/components/widgets/fade_transition.dart';
import 'package:alfa_project/components/widgets/image_widget.dart';
import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:alfa_project/provider/search_text_img_bloc.dart';
import 'package:alfa_project/provider/story_bloc.dart';
import 'package:alfa_project/screens/home/create_image_story.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StickerTextPicker extends StatelessWidget {
  final int id;
  final bool isTextBase;
  final bool isDecoration;
  final bool isTextToImage;

  final String text;
  final String title;
  const StickerTextPicker({
    Key key,
    this.id,
    this.isDecoration = false,
    this.isTextToImage,
    this.title,
    this.isTextBase,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchTextImageBloc>(context, listen: false);

    final storyBloc = Provider.of<StoryBloc>(context);

    return Scaffold(
      backgroundColor: Color(0xFF6E7886).withOpacity(0.8),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.transparent,
          padding: const EdgeInsets.all(0),
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          isDecoration ? '$title' : '$title',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 17.0.sp,
            fontFamily: 'SF Pro Display',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 35,
              width: 35,
              child: BounceButton(
                onPressed: () {
                  bloc.setClearData();

                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                iconImagePath: IconsClass.closeIcon,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              !isDecoration
                  ? isTextBase
                      ? FutureBuilder(
                          future: bloc.getTextId(this.id),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null)
                              return Center(
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
                              );
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data['data'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        storyBloc.setTitleBodyString(
                                            snapshot.data['data'][index]
                                                ['title'],
                                            snapshot.data['data'][index]
                                                ['text']);
                                        final bloc1 =
                                            Provider.of<SearchTextImageBloc>(
                                                context,
                                                listen: false);
                                        bloc1.setClearData();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      title: Text(
                                        snapshot.data['data'][index]['title']
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: Text(
                                          snapshot.data['data'][index]['text']
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.0.sp,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Divider(
                                      indent: 20,
                                      endIndent: 20,
                                      thickness: 0.5,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 0.1),
                                      height: 1,
                                    )
                                  ],
                                );
                              },
                            );
                          },
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
                                      height: 25,
                                      width: 25,
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
                                    onTap: () {
                                      storyBloc.setLoading(true);
                                      if (isTextToImage) {
                                        Navigator.of(context).pushReplacement(
                                          FadeRouteBuilder(
                                            page: CreateEditTemplateScreen(
                                              imageUrl: snapshot.data['data']
                                                  [index]['url'],
                                            ),
                                          ),
                                        );
                                        log("message");
                                      } else {
                                        storyBloc.setImageSticker(
                                          snapshot.data['data'][index]['url'],
                                        );
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
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
                      future: bloc.getImages(116, context),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null)
                          return Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Platform.isAndroid
                                  ? const Center(
                                      child: SizedBox(
                                        height: 25,
                                        width: 25,
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(5),
                            child: CachedNetworkImage(
                              imageUrl: BASE_URL_IMAGE +
                                  snapshot.data['data'][index]['icon'],
                              imageBuilder: (context, imageProvider) => InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  storyBloc.setWidgetChildren(
                                    ImageWidget(
                                      isSaved: false,
                                      imageUrl: snapshot.data['data'][index]
                                          ['url'],
                                    ),
                                  );
                                  if (this.isDecoration) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    Navigator.pop(context);
                                  }
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
        ],
      ),
    );
  }
}
