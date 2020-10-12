import 'dart:io';

import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:alfa_project/provider/search_text_image.dart';
import 'package:alfa_project/screens/home/create_edit_template.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class StickerTextPicker extends StatelessWidget {
  final int id;
  final bool isTextBase;
  final String text;
  final String title;
  const StickerTextPicker({
    Key key,
    this.id,
    this.title,
    this.isTextBase,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchTextImageBloc>(context, listen: false);

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
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        const Text(
                          'Назад',
                          style: TextStyle(
                            fontSize: 16,
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
                    '$title',
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
                    height: 30,
                    width: 30,
                    child: BounceButton(
                      onPressed: () {
                        bloc.setClearData();
                        Navigator.pop(context);
                      },
                      iconImagePath: SvgPicture.asset(
                        'assets/images/svg/custom_icons/close.svg',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            isTextBase
                ? ListTile(
                    onTap: () => Navigator.pop(
                      context,
                    ),
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
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                                snapshot.data['data'][index]['url'],
                            imageBuilder: (context, imageProvider) => InkWell(
                              borderRadius: BorderRadius.circular(5),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CreateEditTemplateScreen(
                                    imageProvider: imageProvider,
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
