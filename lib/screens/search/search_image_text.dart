import 'dart:developer';

import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/provider/search_text_image.dart';
import 'package:alfa_project/screens/search/picker_image_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:alfa_project/components/icons/custom_icons.dart';
import 'package:provider/provider.dart';

class SearchPickerScreen extends StatefulWidget {
  final bool isText;
  final bool isTextToImage;
  SearchPickerScreen({Key key, this.isText, this.isTextToImage})
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
    return await bloc.getTextBase();
  }

  @override
  Widget build(BuildContext context) {
    final mainTextStyle = TextStyle(
      color: Colors.white,
      fontSize: 17,
      fontWeight: FontWeight.w300,
    );
    final bloc = Provider.of<SearchTextImageBloc>(context, listen: true);

    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Color(0xFF6E7886).withOpacity(0.8),
          resizeToAvoidBottomPadding: false,
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 19, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isText ? 'База текстов' : 'Стикеры',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
              ),
              widget.isText
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color.fromRGBO(255, 255, 255, 0.1),
                        ),
                        child: TextField(
                            cursorColor: Colors.white,
                            cursorWidth: 2,
                            cursorRadius: Radius.circular(3),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[300],
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Поиск',
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey[200],
                                fontSize: 15,
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
                      height: 30,
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
                        // log('${snapshot.data}');
                        return Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              addAutomaticKeepAlives: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (_, index) {
                                if (snapshot.data[index]['id'] == 116)
                                  return SizedBox();
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              StickerTextPicker(
                                            isTextToImage: widget.isTextToImage,
                                            id: snapshot.data[index]['id'],
                                            title: widget.isText
                                                ? snapshot.data[index]['title']
                                                : snapshot.data[index]['text'],
                                            isTextBase:
                                                widget.isText ? true : false,
                                            text: snapshot.data[index]['text'],
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        widget.isText
                                            ? '${snapshot.data[index]['title']}'
                                            : '${snapshot.data[index]['text']}',
                                        style: mainTextStyle,
                                      ),
                                      trailing: const SizedBox(
                                        width: 20,
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.white,
                                            size: 20,
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
                          itemCount: bloc.getSearchText['data'].length,
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
                                      id: bloc.getSearchText['data'][i]['id'],
                                      title: bloc.getSearchText['data'][i]
                                          ['title'],
                                      text: bloc.getSearchText['data'][i]
                                          ['text'],
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                '${bloc.getSearchText['data'][i]['title']}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  '${bloc.getSearchText['data'][i]['text']}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
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
      bloc.searchText(val, context);
    } else {
      bloc.setClearData();
    }
  }
}
