import 'package:alfa_project/core/data/consts/app_const.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class ImageWidget extends StatefulWidget {
  final String imageUrl;
  final VoidCallback saveFunc;
  final bool isSaved;
  ImageWidget({Key key, this.imageUrl, this.saveFunc, this.isSaved})
      : super(key: key);

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  Matrix4 _localImagePosition = Matrix4.identity();
  bool _isPositionSaved = false;
  bool isSuccessful = false;
  bool showTrash = false;

  @override
  void initState() {
    notifier.addListener(() {
      this._localImagePosition = notifier.value;
      // log("$_localImagePosition");
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // log('${storyBloc.getRemoveEnabled}');
    return IgnorePointer(
      ignoring: false,
      child: CachedNetworkImage(
        imageUrl: BASE_URL_IMAGE + widget.imageUrl,
        imageBuilder: (context, imageProvider) {
          return MatrixGestureDetector(
            key: UniqueKey(),
            onMatrixUpdate: (m, tm, sm, rm) {
              notifier.value = m;
            },
            child: !_isPositionSaved
                ? AnimatedBuilder(
                    animation: notifier,
                    builder: (ctx, child) {
                      return Transform(
                        transform: notifier.value,
                        child: Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Image(image: imageProvider),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : Transform(
                    transform: _localImagePosition,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image(image: imageProvider),
                      ],
                    ),
                  ),
          );
        },
        placeholder: (context, url) => Container(
          color: Colors.grey,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.white,
            ),
          ),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
