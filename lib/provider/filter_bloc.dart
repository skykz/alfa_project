import 'dart:developer';
import 'dart:io';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/core/repository/api_repository.dart';
import 'package:alfa_project/screens/home/filter_image_color.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photofilters/filters/filters.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:path/path.dart';

import 'package:image/image.dart' as imageLib;

class FilterBloc extends ChangeNotifier {
  AlfaApi _alfaApi = AlfaApi();

  dynamic _listTemplates;
  dynamic get getListTemplates => _listTemplates;
  bool _isLoading = false;
  bool _isLoadingImage = false;
  bool get getImageLoading => _isLoadingImage;
  bool get getLoading => _isLoading;
  File _file;
  File get getPickedFile => _file;

  FilterBloc() {
    getTemplates();
  }

  Future getTemplates() async {
    setLoading(true);
    _alfaApi.getCategory().then((value) {
      if (value != null) {
        for (var i = 0; i < value.length; i++) {
          if (value[i]['name'] == 'template')
            _alfaApi.getImage(value[i]['id']).then((value) {
              if (value != null) setUrlImages(value);
            }).whenComplete(() => setLoading(false));
        }
      }
    });
  }

  setLoading(bool val) {
    this._isLoading = val;
    notifyListeners();
  }

  setImageLoading(bool val) {
    this._isLoadingImage = val;
    notifyListeners();
  }

  setUrlImages(dynamic val) {
    this._listTemplates = val;
    notifyListeners();
  }

  pickFileFrom(BuildContext context) async {
    String fileName;

    FilePickerResult result;
    result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      setImageLoading(true);
      File file;
      file = File(result.files.single.path);
      Navigator.pop(context);

      log("${file.path}");
      if (file.path != null) {
        fileName = basename(file.path);
        final imageMain = imageLib.decodeImage(file.readAsBytesSync());
        // final imagePreview = imageLib.copyResize(imageMain,
        //     height: MediaQuery.of(context).size.height.toInt(),
        //     width: MediaQuery.of(context).size.width.toInt());

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoFilterSelector(
              title: Text("Photo Filter Example"),
              image: imageMain,
              filters: _filters,
              // imagePreview: imagePreview,
              appBarColor: AppStyle.colorRed,
              filename: fileName,
              loader: Center(
                child: Platform.isAndroid
                    ? SizedBox(
                        height: 25,
                        width: 25,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : CupertinoActivityIndicator(
                        radius: 15,
                      ),
              ),
              fit: BoxFit.contain,
            ),
          ),
        );
        setImageLoading(false);
      }
      setImageLoading(false);

      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => FilterImageEditor(
      //       file: file,
      //     ),
      //   ),
      // );
    }
  }

  setPickedFile(File _file) {
    this._file = _file;
    notifyListeners();
  }

  List<Filter> _filters = [
    BrannanFilter(),
    F1977Filter(),
    XProIIFilter(),
    ReyesFilter(),
    SkylineFilter(),
  ];
}
