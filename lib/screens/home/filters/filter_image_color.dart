import 'dart:async';
import 'dart:io';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:flutter/cupertino.dart';

import 'create_edit_filters_template.dart';

class PhotoFilter extends StatelessWidget {
  final imageLib.Image image;
  final String filename;
  final Filter filter;
  final BoxFit fit;
  final Widget loader;

  PhotoFilter({
    @required this.image,
    @required this.filename,
    @required this.filter,
    this.fit = BoxFit.fill,
    this.loader = const Center(child: CircularProgressIndicator()),
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: compute(applyFilter, <String, dynamic>{
        "filter": filter,
        "image": image,
        "filename": filename,
      }),
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return loader;
          case ConnectionState.active:
          case ConnectionState.waiting:
            return loader;
          case ConnectionState.done:
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            return Image.memory(
              snapshot.data,
              fit: fit,
            );
        }
        return null; // unreachable
      },
    );
  }
}

///The PhotoFilterSelector Widget for apply filter from a selected set of filters
class PhotoFilterSelector extends StatefulWidget {
  final Color appBarColor;
  final List<Filter> filters;
  final String templateId;
  final imageLib.Image image;
  // final imageLib.Image imagePreview;

  final Widget loader;
  final BoxFit fit;
  final String filename;
  final bool circleShape;

  const PhotoFilterSelector({
    Key key,
    @required this.filters,
    @required this.image,
    this.templateId,
    // @required this.imagePreview,
    this.appBarColor = Colors.blue,
    this.loader = const Center(child: CircularProgressIndicator()),
    this.fit = BoxFit.fill,
    @required this.filename,
    this.circleShape = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _PhotoFilterSelectorState();
}

class _PhotoFilterSelectorState extends State<PhotoFilterSelector> {
  String filename;
  Map<String, List<int>> cachedFilters = {};
  Filter _filter;
  imageLib.Image image;
  imageLib.Image imagePreview;

  bool loading;

  @override
  void initState() {
    super.initState();
    loading = false;
    _filter = widget.filters[0];
    filename = widget.filename;
    image = widget.image;
    // imagePreview = widget.imagePreview;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Выберите фильтр",
            style: TextStyle(
              color: AppStyle.colorDark,
            ),
          ),
          actions: <Widget>[
            loading
                ? !Platform.isIOS
                    ? SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : CupertinoActivityIndicator(
                        radius: 10,
                      )
                : IconButton(
                    icon: Icon(
                      Icons.check,
                      size: 32,
                      color: AppStyle.colorRed,
                    ),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await saveFilteredImage();

                      // Navigator.pop(context, {'image_filtered': imageFile});
                    },
                  )
          ],
          elevation: 10,
          shadowColor: Colors.grey[300],
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: AppStyle.colorDark,
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: loading
              ? widget.loader
              : Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        padding: EdgeInsets.all(12.0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: _buildFilteredImage(
                            _filter,
                            image,
                            filename,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.filters.length,
                          addAutomaticKeepAlives: true,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    _buildFilterThumbnail(widget.filters[index],
                                        image, filename, index),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Text(
                                      widget.filters[index].name,
                                    )
                                  ],
                                ),
                              ),
                              onTap: () => setState(() {
                                _filter = widget.filters[index];
                              }),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _buildFilterThumbnail(
      Filter filter, imageLib.Image image, String filename, int index) {
    if (cachedFilters[filter?.name ?? "_"] == null) {
      return FutureBuilder<List<int>>(
        future: compute(applyFilter, <String, dynamic>{
          "filter": filter,
          "image": image,
          "filename": filename,
        }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return CircleAvatar(
                radius: 40,
                child: Center(
                  child: widget.loader,
                ),
                backgroundColor: Colors.white,
              );
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              cachedFilters[filter?.name ?? "_"] = snapshot.data;
              return CircleAvatar(
                radius: 40,
                backgroundImage: MemoryImage(
                  snapshot.data,
                ),
                backgroundColor: Colors.white,
              );
          }
          return null; // unreachable
        },
      );
    } else {
      return Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: Colors.red[200],
          image: DecorationImage(
            image: MemoryImage(
              cachedFilters[filter?.name ?? "_"],
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
          border: _filter == widget.filters[index]
              ? Border.all(
                  color: Colors.red,
                  width: 4.0,
                )
              : null,
        ),
      );
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/filtered_${_filter?.name ?? "_"}_$filename');
  }

  Future<File> saveFilteredImage() async {
    var imageFile = await _localFile;
    await imageFile.writeAsBytes(cachedFilters[_filter?.name ?? "_"]);
    // GallerySaver.saveImage(imageFile.path);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditFilterTemplateScreen(
          templateImageId: widget.templateId,
          filteredImage: imageFile,
        ),
      ),
    );

    return imageFile;
  }

  Widget _buildFilteredImage(
      Filter filter, imageLib.Image image, String filename) {
    if (cachedFilters[filter?.name ?? "_"] == null) {
      return FutureBuilder<List<int>>(
        future: compute(applyFilter, <String, dynamic>{
          "filter": filter,
          "image": image,
          "filename": filename,
        }),
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return widget.loader;
            case ConnectionState.active:
            case ConnectionState.waiting:
              return widget.loader;
            case ConnectionState.done:
              if (snapshot.hasError)
                return Center(child: Text('Error: ${snapshot.error}'));
              cachedFilters[filter?.name ?? "_"] = snapshot.data;
              return widget.circleShape
                  ? SizedBox(
                      height: MediaQuery.of(context).size.width / 3,
                      width: MediaQuery.of(context).size.width / 3,
                      child: Center(
                        child: CircleAvatar(
                          radius: MediaQuery.of(context).size.width / 3,
                          backgroundImage: MemoryImage(
                            snapshot.data,
                          ),
                        ),
                      ),
                    )
                  : Image.memory(
                      snapshot.data,
                      fit: BoxFit.contain,
                    );
          }
          return null; // unreachable
        },
      );
    } else {
      return widget.circleShape
          ? SizedBox(
              height: MediaQuery.of(context).size.width / 3,
              width: MediaQuery.of(context).size.width / 3,
              child: Center(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 3,
                  backgroundImage: MemoryImage(
                    cachedFilters[filter?.name ?? "_"],
                  ),
                ),
              ),
            )
          : Image.memory(
              cachedFilters[filter?.name ?? "_"],
              fit: widget.fit,
            );
    }
  }
}

///The global applyfilter function
List<int> applyFilter(Map<String, dynamic> params) {
  Filter filter = params["filter"];
  imageLib.Image image = params["image"];
  String filename = params["filename"];
  List<int> _bytes = image.getBytes();
  if (filter != null) {
    filter.apply(_bytes, image.width, image.height);
  }
  imageLib.Image _image =
      imageLib.Image.fromBytes(image.width, image.height, _bytes);
  _bytes = imageLib.encodeNamedImage(_image, filename);

  return _bytes;
}

///The global buildThumbnail function
List<int> buildThumbnail(Map<String, dynamic> params) {
  int width = params["width"];
  params["image"] = imageLib.copyResize(params["image"], width: width);
  return applyFilter(params);
}
