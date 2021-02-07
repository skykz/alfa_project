import 'dart:io';

import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/provider/search_text_img_bloc.dart';
import 'package:alfa_project/screens/search/picker_image_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter/services.dart';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:provider/provider.dart';

class SearchPickerScreen extends StatefulWidget {
  final bool isText;
  final bool isTextToImage;
  final bool isDecorationCategory;
  SearchPickerScreen(
      {Key key,
      this.isText,
      this.isTextToImage,
      this.isDecorationCategory = false})
      : super(key: key);

  @override
  _SearchPickerScreenState createState() => _SearchPickerScreenState();
}

class _SearchPickerScreenState extends State<SearchPickerScreen> {
  List<dynamic> categoriesList = List();
  Future<dynamic> getCategory;
  Future<dynamic> getTextBase;

  @override
  void initState() {
    super.initState();
    if (widget.isText)
      getTextBase = _getTextBase();
    else
      getCategory = _getCategories();
  }

  Future _getCategories() async {
    final bloc = Provider.of<SearchTextImageBloc>(context, listen: false);
    return await bloc.getCategories();
  }

  Future _getTextBase() async {
    final bloc = Provider.of<SearchTextImageBloc>(context, listen: false);
    return await bloc.getTextBaseCategory();
  }

  _setClear() {
    final bloc = Provider.of<SearchTextImageBloc>(context, listen: false);
    bloc.setClearData();
  }

  @override
  Widget build(BuildContext context) {
    final mainTextStyle = TextStyle(
      color: Colors.white,
      fontFamily: 'SF Pro Display Regular',
      fontSize: 13.0.sp,
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color(0xFF6E7886).withOpacity(0.8),
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          leadingWidth: 0,
          primary: true,
          brightness: Platform.isAndroid ? Brightness.light : Brightness.dark,
          elevation: 0,
          centerTitle: false,
          title: Text(
            widget.isText ? 'База текстов' : 'Стикеры',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.bold,
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 35,
                width: 35,
                child: BounceButton(
                  onPressed: () {
                    _setClear();
                    Navigator.pop(context);
                  },
                  iconImagePath: IconsClass.closeIcon,
                ),
              ),
            ),
          ],
        ),
        body: Consumer<SearchTextImageBloc>(
          builder: (context, bloc, child) => Column(
            children: [
              widget.isText
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        child: TextField(
                            cursorColor: Colors.white,
                            cursorWidth: 2,
                            cursorRadius: Radius.circular(3),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[300],
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              hintText: 'Поиск',
                              prefixIcon: SizedBox(
                                height: 10,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: SvgPicture.asset(
                                    'assets/images/svg/search.svg',
                                    height: 0,
                                    width: 0,
                                  ),
                                ),
                              ),
                              alignLabelWithHint: false,
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            onEditingComplete: () {},
                            onSubmitted: (val) {},
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[^\s\\]'))
                            ],
                            onChanged: (val) {
                              _searchText(val);
                            }),
                      ),
                    )
                  : const SizedBox(
                      height: 10,
                    ),
              bloc.getSearchText.length == 0
                  ? FutureBuilder(
                      future: widget.isText ? getTextBase : getCategory,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null)
                          return const Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: Colors.white,
                              ),
                            ),
                          );
                        return Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              addAutomaticKeepAlives: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (_, index) {
                                if (this.widget.isDecorationCategory) {
                                  if (snapshot.data[index]['id'] == 107)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 108)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 109)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 110)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 111)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 112)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 113)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 114)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 117)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 118)
                                    return const SizedBox();
                                } else {
                                  if (snapshot.data[index]['id'] == 116)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 111)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 121)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 120)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 119)
                                    return const SizedBox();
                                  if (snapshot.data[index]['id'] == 115)
                                    return const SizedBox();
                                }

                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StickerTextPicker(
                                            isDecoration:
                                                widget.isDecorationCategory,
                                            isTextToImage: widget.isTextToImage,
                                            id: snapshot.data[index]['id'],
                                            title: snapshot.data[index]['text'],
                                            isTextBase:
                                                widget.isText ? true : false,
                                            text: snapshot.data[index]['text'],
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        widget.isText
                                            ? '${snapshot.data[index]['text']}'
                                            : '${snapshot.data[index]['text']}',
                                        style: mainTextStyle,
                                      ),
                                      trailing: SizedBox(
                                        width: 20,
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.white,
                                            size: 15.0.sp,
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
                                      height: 0.5,
                                    )
                                  ],
                                );
                              }),
                        );
                      },
                    )
                  : Expanded(
                      child: ListView.separated(
                          itemCount: bloc.getSearchText.length,
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => Divider(
                                thickness: 1,
                                color: const Color.fromRGBO(255, 255, 255, 0.1),
                                height: 1,
                              ),
                          itemBuilder: (context, i) {
                            return ListTile(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StickerTextPicker(
                                      isTextToImage: widget.isTextToImage,
                                      isTextBase: true,
                                      id: bloc.getSearchText[i]['id'],
                                      title: bloc.getSearchText[i]['title'],
                                      text: bloc.getSearchText[i]['text'],
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                '${bloc.getSearchText[i]['title']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  '${bloc.getSearchText[i]['text']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.0.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _searchText(String val) {
    final bloc = Provider.of<SearchTextImageBloc>(context, listen: false);

    if (val.length != 0) {
      bloc.searchText(val.trim(), context);
    } else {
      bloc.setClearData();
    }
  }
}
