import 'package:alfa_project/provider/search_text_image.dart';
import 'package:alfa_project/screens/search/picker_image_text.dart';
import 'package:flutter/material.dart';
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
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            widget.isText
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Container(
                      // height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                      ),
                      child: TextField(
                          cursorColor: Colors.white,
                          cursorWidth: 2,
                          cursorRadius: Radius.circular(3),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[300],
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Поиск',
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey[200],
                              fontSize: 20,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0,
                            ),
                          ),
                          onChanged: (val) => _searchText(val)),
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
                            color: const Color.fromRGBO(255, 255, 255, 0.1),
                            height: 1,
                          ),
                          itemCount: snapshot.data.length,
                          itemBuilder: (_, index) => ListTile(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StickerTextPicker(
                                  id: snapshot.data[index]['id'],
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
                          ),
                        ),
                      );
                    },
                  )
                : ListView.separated(
                    itemCount: bloc.getSearchText.length,
                    separatorBuilder: (context, index) => Divider(
                          thickness: 1,
                          color: const Color.fromRGBO(255, 255, 255, 0.1),
                          height: 1,
                        ),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Text('${bloc.getSearchText['data'][index]['title']}'),
                          Text("data"),
                        ],
                      );
                    }),
          ],
        ),
      ),
    );
  }

  _searchText(String val) {
    if (val.length != null) {
      final bloc = Provider.of<SearchTextImageBloc>(context, listen: false);
      bloc.searchText(val, context);
    }
  }
}
