import 'package:alfa_project/components/widgets/bounce_button.dart';
import 'package:alfa_project/provider/search_text_image.dart';
import 'package:alfa_project/screens/search/picker_image_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SearchPickerScreen extends StatefulWidget {
  final bool isText;
  SearchPickerScreen({Key key, this.isText}) : super(key: key);

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
      fontSize: 20,
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
                padding: const EdgeInsets.only(left: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isText ? 'База текстов' : 'Стикеры',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
              ),
              widget.isText
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
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
                                child: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                              ),
                              hintStyle: TextStyle(
                                color: Colors.grey[200],
                                fontSize: 18,
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
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              backgroundColor: Colors.white,
                            ),
                          );
                        return Expanded(
                          child: ListView.separated(
                              shrinkWrap: true,
                              separatorBuilder: (_, index) => Divider(
                                    thickness: 1,
                                    color: const Color.fromRGBO(
                                        255, 255, 255, 0.1),
                                    height: 1,
                                  ),
                              itemCount: snapshot.data.length,
                              itemBuilder: (_, index) {
                                if (snapshot.data[index]['id'] == 115)
                                  return null;

                                return ListTile(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StickerTextPicker(
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
                                  trailing: SizedBox(
                                    width: 20,
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
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
                              // trailing: SizedBox(
                              //   width: 20,
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.max,
                              //     children: [
                              //       Expanded(
                              //         child: Center(
                              //           child: Icon(
                              //             Icons.arrow_forward_ios,
                              //             color: Colors.white,
                              //             size: 20,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
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
