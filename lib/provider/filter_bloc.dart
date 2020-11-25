import 'dart:developer';
import 'dart:io';

import 'package:alfa_project/components/styles/app_style.dart';
import 'package:alfa_project/core/repository/api_repository.dart';
import 'package:alfa_project/screens/home/filters/filter_image_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  List<Filter> _filters = [
    NoFilter(),
    BrannanFilter(),
    F1977Filter(),
    XProIIFilter(),
    ReyesFilter(),
    SkylineFilter(),
  ];

  FilterBloc(BuildContext context) {
    getTemplates(context);
  }

  getTemplates(BuildContext context) {
    setLoading(true);
    _alfaApi.getCategory().then((value) {
      if (value != null) {
        for (var i = 0; i < value.length; i++) {
          if (value[i]['name'] == 'template')
            _alfaApi.getImage(value[i]['id'], context).then((value) {
              if (value != null) {
                this._listTemplates = value;
              }
            }).whenComplete(() => setLoading(false));
          notifyListeners();
        }
      }
    });
  }

  setLoading(bool val) {
    this._isLoading = val;
    notifyListeners();
  }

  setClearFilterData() {
    this._file = null;
    this._isLoading = false;
    this._isLoadingImage = false;
    this._listTemplates = null;
    notifyListeners();
  }

  setImageLoading(bool val) {
    this._isLoadingImage = val;
    notifyListeners();
  }

  pickFileFromGallery(BuildContext context, String templateStringUrl) async {
    String fileName;
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Navigator.pop(context);

      File file;
      file = File(pickedFile.path);

      log("${file.path}");
      if (file.path != null) {
        fileName = basename(file.path);
        final imageMain = imageLib.decodeImage(file.readAsBytesSync());
        _goToFilterScreen(context, imageMain, templateStringUrl, fileName);
      }
      setImageLoading(false);
    } else {
      setImageLoading(false);
    }
  }

  setPickedFile(File _file) {
    this._file = _file;
    notifyListeners();
  }

  Future getCamerImage(BuildContext context, String templateStringUrl) async {
    File _image;
    String fileName;

    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setImageLoading(true);
      _image = File(pickedFile.path);

      File file;
      file = File(_image.path);

      log("${file.path}");
      if (file.path != null) {
        fileName = basename(file.path);
        final imageMain = imageLib.decodeImage(file.readAsBytesSync());
        final image = imageLib.copyResize(imageMain, width: 800);
        _goToFilterScreen(context, image, templateStringUrl, fileName);
      }
    } else {
      setImageLoading(false);
      print('No image selected.');
    }

    return _image;
  }

  _goToFilterScreen(BuildContext context, imageMain, String templateStringUrl,
      String fileName) {
    setImageLoading(false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoFilterSelector(
          image: imageMain,
          filters: _filters,
          templateId: templateStringUrl,
          appBarColor: AppStyle.colorRed,
          filename: fileName,
          loader: Center(
            child: Platform.isAndroid
                ? const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const CupertinoActivityIndicator(
                    radius: 15,
                  ),
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
