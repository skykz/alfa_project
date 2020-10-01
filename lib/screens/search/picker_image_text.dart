import 'package:alfa_project/provider/search_text_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StickerTextPicker extends StatelessWidget {
  final int id;
  const StickerTextPicker({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<SearchTextImageBloc>(context, listen: false);
    bloc.getImages(id, context);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: null,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemBuilder: (context, index) => Container(),
            );
          },
        ),
      ),
    );
  }
}
